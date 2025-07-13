using Assets.Scripts.Audio;
using System.Collections.Generic;
using UnityEngine;
using System.Linq;
using System;
using Assets.Scripts.ReactiveEffects.Base;
using Assets.Scripts.ReactiveEffects;

public class LoopbackAudio : MonoBehaviour
{
    #region Constants

    private const int EnergyAverageCount = 100;

    #endregion

    #region Private Member Variables

    private RealtimeAudio _realtimeAudio;
    private List<float> _postScaleAverages = new List<float>();

    #endregion

    #region Public Properties

    [HideInInspector]
    public int SpectrumSize;

    public GameObject barsContainer;
    public ScalingStrategy ScalingStrategy;
    public float[] SpectrumData;
    public float[] PostScaledSpectrumData;
    public float[] PostScaledMinMaxSpectrumData;
    public float PostScaledMax;
    public float PostScaledEnergy;
    public bool IsIdle;

    // Set through editor, but good values are 0.8, 0.5, 1.2, 1.5 respectively
    public float ThresholdToMin;
    public float MinAmount;
    public float ThresholdToMax;
    public float MaxAmount;

    [Tooltip("La largeur totale que la ligne doit occuper dans la scène.")]
    public float desiredTotalWidth = 10f;

    // L'espacement est maintenant fixe à 1, comme demandé.
    private const float itemSpacing = 1f;
    private int objectCount = 1; // Garde en mémoire le nombre d'objets actuel

    #endregion

    #region Startup / Shutdown

    public void Awake()
    {
        InitializeSpectrum();
    }

    void InitializeSpectrum()
    {
        for (int i = 0; i < barsContainer.transform.childCount; i++)
        {

            if (barsContainer.transform.GetChild(i).GetComponent<ObjectScaleReactiveEffect>() != null)
                barsContainer.transform.GetChild(i).GetComponent<ObjectScaleReactiveEffect>().AudioSampleIndex = i;
            if (barsContainer.transform.GetChild(i).GetComponent<MaterialColorIntensityReactiveEffect>() != null)
                barsContainer.transform.GetChild(i).GetComponent<MaterialColorIntensityReactiveEffect>().AudioSampleIndex = i;
        }

        Launchloopback();

        objectCount = barsContainer.transform.childCount;
        UpdateScale();
        RepositionAllObjects();
    }

    public void Launchloopback()
    {
        SpectrumSize = barsContainer.transform.childCount;

        SpectrumData = new float[SpectrumSize];
        PostScaledSpectrumData = new float[SpectrumSize];
        PostScaledMinMaxSpectrumData = new float[SpectrumSize];

        // Used for post scaling
        float postScaleStep = 1.0f / SpectrumSize;

        // Setup loopback audio and start listening
        _realtimeAudio = new RealtimeAudio(SpectrumSize, ScalingStrategy,(spectrumData) =>
        {
            // Raw
            SpectrumData = spectrumData;

            // Post scaled for visualization
            float postScaledPoint = postScaleStep;
            float postScaledMax = 0.0f;

            float postScaleAverage = 0.0f;
            float totalPostScaledValue = 0.0f;

            bool isIdle = true;

            // Pass 1: Scaled. Scales progressively as moving up the spectrum
            for (int i = 0; i < SpectrumSize; i++)
            {
                // Don't scale low band, it's too useful
                if (i == 0)
                {
                    PostScaledSpectrumData[i] = SpectrumData[i];
                }
                else
                {
                    float postScaleValue = postScaledPoint * SpectrumData[i] * (RealtimeAudio.MaxAudioValue);// - (1.0f - postScaledPoint));
                    PostScaledSpectrumData[i] = Mathf.Clamp(postScaleValue, 0, RealtimeAudio.MaxAudioValue); // TODO: Can this be done better than a clamp?
                }

                if (PostScaledSpectrumData[i] > postScaledMax)
                {
                    postScaledMax = PostScaledSpectrumData[i];
                }

                postScaledPoint += postScaleStep;
                totalPostScaledValue += PostScaledSpectrumData[i];

                if (spectrumData[i] > 0)
                {
                    isIdle = false;
                }
            }

            PostScaledMax = postScaledMax;

            // Calculate "energy" using the post scale average
            postScaleAverage = totalPostScaledValue / SpectrumSize;
            _postScaleAverages.Add(postScaleAverage);

            // We only want to track EnergyAverageCount averages.
            // With a value of 1000, this will happen every couple seconds
            if (_postScaleAverages.Count == EnergyAverageCount)
            {
                _postScaleAverages.RemoveAt(0);
            }

            // Average the averages to get the energy.
            PostScaledEnergy = _postScaleAverages.Average();

            // Pass 2: MinMax spectrum. Here we use the average.
            // If a given band falls below the average, reduce it 50%
            // otherwise boost it 50%
            for (int i = 0; i < SpectrumSize; i++)
            {
                float minMaxed = PostScaledSpectrumData[i];

                if(minMaxed <= postScaleAverage * ThresholdToMin)
                {
                    minMaxed *= MinAmount;
                }
                else if(minMaxed >= postScaleAverage * ThresholdToMax)
                {
                    minMaxed *= MaxAmount;
                }

                PostScaledMinMaxSpectrumData[i] = minMaxed;
            }

            IsIdle = isIdle;
        });
        _realtimeAudio.StartListen();
    }

    public void MyChangeAudioMode(int strategyInt)
    {
        _realtimeAudio.StopListen();

        SpectrumSize = barsContainer.transform.childCount;

        SpectrumData = new float[SpectrumSize];
        PostScaledSpectrumData = new float[SpectrumSize];
        PostScaledMinMaxSpectrumData = new float[SpectrumSize];

        // Used for post scaling
        float postScaleStep = 1.0f / SpectrumSize;

        switch (strategyInt)
        {
            case 0:
                ScalingStrategy = ScalingStrategy.Decibel;
                break;
            case 1:
                ScalingStrategy = ScalingStrategy.Linear;
                break;
            case 2:
                ScalingStrategy = ScalingStrategy.Sqrt;
                break;
            default:
                throw new InvalidOperationException(string.Format("Invalid for GetAllSpectrumData: {0}", ScalingStrategy));
        }

        // Setup loopback audio and start listening
        _realtimeAudio = new RealtimeAudio(SpectrumSize, ScalingStrategy, (spectrumData) =>
        {
            // Raw
            SpectrumData = spectrumData;

            // Post scaled for visualization
            float postScaledPoint = postScaleStep;
            float postScaledMax = 0.0f;

            float postScaleAverage = 0.0f;
            float totalPostScaledValue = 0.0f;

            bool isIdle = true;

            // Pass 1: Scaled. Scales progressively as moving up the spectrum
            for (int i = 0; i < SpectrumSize; i++)
            {
                // Don't scale low band, it's too useful
                if (i == 0)
                {
                    PostScaledSpectrumData[i] = SpectrumData[i];
                }
                else
                {
                    float postScaleValue = postScaledPoint * SpectrumData[i] * (RealtimeAudio.MaxAudioValue - (1.0f - postScaledPoint));
                    PostScaledSpectrumData[i] = Mathf.Clamp(postScaleValue, 0, RealtimeAudio.MaxAudioValue); // TODO: Can this be done better than a clamp?
                }

                if (PostScaledSpectrumData[i] > postScaledMax)
                {
                    postScaledMax = PostScaledSpectrumData[i];
                }

                postScaledPoint += postScaleStep;
                totalPostScaledValue += PostScaledSpectrumData[i];

                if (spectrumData[i] > 0)
                {
                    isIdle = false;
                }
            }

            PostScaledMax = postScaledMax;

            // Calculate "energy" using the post scale average
            postScaleAverage = totalPostScaledValue / SpectrumSize;
            _postScaleAverages.Add(postScaleAverage);

            // We only want to track EnergyAverageCount averages.
            // With a value of 1000, this will happen every couple seconds
            if (_postScaleAverages.Count == EnergyAverageCount)
            {
                _postScaleAverages.RemoveAt(0);
            }

            // Average the averages to get the energy.
            PostScaledEnergy = _postScaleAverages.Average();

            // Pass 2: MinMax spectrum. Here we use the average.
            // If a given band falls below the average, reduce it 50%
            // otherwise boost it 50%
            for (int i = 0; i < SpectrumSize; i++)
            {
                float minMaxed = PostScaledSpectrumData[i];

                if (minMaxed <= postScaleAverage * ThresholdToMin)
                {
                    minMaxed *= MinAmount;
                }
                else if (minMaxed >= postScaleAverage * ThresholdToMax)
                {
                    minMaxed *= MaxAmount;
                }

                PostScaledMinMaxSpectrumData[i] = minMaxed;
            }

            IsIdle = isIdle;
        });
        _realtimeAudio.StartListen();
    }

    public void Update()
    {
        float scrollInput = Input.GetAxis("Mouse ScrollWheel");

        if (scrollInput > 0f) // Si la molette défile vers le haut
        {
            _realtimeAudio.StopListen();
            SetObjectCount(objectCount + 1);
            InitializeSpectrum();
        }
        else if (scrollInput < 0f) // Si la molette défile vers le bas
        {
            _realtimeAudio.StopListen();
            SetObjectCount(objectCount - 1);
            InitializeSpectrum();
        }
    }

    public void OnApplicationQuit()
    {
        _realtimeAudio.StopListen();
    }

    #endregion

    #region Public Methods

    public float[] GetAllSpectrumData(AudioVisualizationStrategy strategy)
    {
        float[] spectrumData;

        switch (strategy)
        {
            case AudioVisualizationStrategy.Raw:
                spectrumData = SpectrumData;
                break;
            case AudioVisualizationStrategy.PostScaled:
                spectrumData = PostScaledSpectrumData;
                break;
            case AudioVisualizationStrategy.PostScaledMinMax:
                spectrumData = PostScaledMinMaxSpectrumData;
                break;
            default:
                throw new InvalidOperationException(string.Format("Invalid for GetAllSpectrumData: {0}", strategy));
        }

        return spectrumData;
    }

    public float GetSpectrumData(AudioVisualizationStrategy strategy, int index = 0)
    {
        float spectrumData = 0.0f;

        switch (strategy)
        {
            case AudioVisualizationStrategy.Raw:
                spectrumData = SpectrumData[index];
                break;
            case AudioVisualizationStrategy.PostScaled:
                spectrumData = PostScaledSpectrumData[index];
                break;
            case AudioVisualizationStrategy.PostScaledMinMax:
                spectrumData = PostScaledMinMaxSpectrumData[index];
                break;
            case AudioVisualizationStrategy.PostScaledMax:
                spectrumData = PostScaledMax;
                break;
            case AudioVisualizationStrategy.PostScaledEnergy:
                spectrumData = PostScaledEnergy;
                break;
        }

        return spectrumData;
    }

    #endregion

    public void SetObjectCount(int count)
    {
        if (count < 1)
        {
            count = 1;
        }

        objectCount = count;

        int currentCount = barsContainer.transform.childCount;

        if (currentCount == 0)
        {
            Debug.LogError("Il n'y a pas d'objet initial à cloner ! Placez un objet enfant sous le LineManager.");
            return;
        }

        GameObject template = barsContainer.transform.GetChild(0).gameObject;

        for (int i = currentCount; i < count; i++)
        {
            GameObject newObj = Instantiate(template, barsContainer.transform);
            newObj.transform.localPosition = new Vector3(i * itemSpacing, 0, 0);
        }

        for (int i = currentCount - 1; i >= count; i--)
        {
            Destroy(barsContainer.transform.GetChild(i).gameObject);
        }
    }

    // Met à jour l'échelle du parent pour conserver la largeur désirée
    private void UpdateScale()
    {
        int childCount = barsContainer.transform.childCount;
        if (childCount == 0)
        {
            barsContainer.transform.localScale = Vector3.one;
            return;
        }

        // La largeur naturelle est le nombre d'objets multiplié par l'espacement
        float naturalWidth = childCount * itemSpacing;
        float newScaleX = (naturalWidth > 0) ? desiredTotalWidth / naturalWidth : 1f;
        barsContainer.transform.localScale = new Vector3(newScaleX, 1f, 1f);
    }

    private void RepositionAllObjects()
    {
        int numberOfObjects = barsContainer.transform.childCount;
        if (numberOfObjects == 0)
        {
            return;
        }

        float centerOfLine = (numberOfObjects * itemSpacing) / 2f;

        for (int i = 0; i < numberOfObjects; i++)
        {
            float xPosition = i * itemSpacing - (centerOfLine * 2);
            barsContainer.transform.localPosition = new Vector3(xPosition, 0, 0);
        }
    }
}
