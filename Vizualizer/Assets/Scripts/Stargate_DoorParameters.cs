using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using static UnityEngine.GraphicsBuffer;
using TMPro;
using static UnityEngine.GridBrushBase;

public class Stargate_DoorParameters : MonoBehaviour
{
    [Header("Keyboard & rotation")]
    public GameObject disc;

    public GameObject[] Keys;
    public Color ActivatedKey;
    public Color DesactivatedKey;

    public bool isStatic = true;
    public float discSpeed = 1.0f;
    [Space(10)]
    [Header("Sequence")]
    public int sequence = 0;
    public int sequenceMaxi = 7;
    public bool seqValidated = false;
    [HideInInspector] public bool canClose = false;
    [Space(10)]
    [Header("Modules")]
    public bool activGen = false;
    public bool activEPPZ = false;
    [Space(10)]
    [Header("Chevrons & Lights")]
    public GameObject[] _chevrons;
    public GameObject[] _lights;
    public bool lockChevron = false;
    public bool unlockChevron = false;
    bool ChevronLockingSequenceSucces = true;
    [HideInInspector] public GameObject[] chevrons;
    GameObject[] lights;
    public GameObject kawoosh;
    public GameObject vortexLight;
    [Space(10)]
    [Header("Animations")]
    public AnimationClip[] anim;
    public bool irisOpen = true;
    public bool irisMoving = false;
    public GameObject vortexObject;
    [Space(10)]
    [Header("Sounds")]
    public AudioClip[] audioClip;
    GameObject soundObject;
    GameObject parallelSoundObject;
    public GameObject soundPrefab;

    GameObject[] chevronsS7;
    GameObject[] chevronsS8;
    GameObject[] chevronsS9;
    GameObject[] lightsS7;
    GameObject[] lightsS8;
    GameObject[] lightsS9;

    private bool isLocking = false;

    bool discRotating = false;
    int discIndex = 0;

    private float targetDiscRotationX;  // Sera l'angle d'Euler X cible pour le disque
    public float rotationStopTolerance = 0.01f; // Tolérance pour arrêter la rotation
    private int rotationDirection = 0; // 1 pour sens positif, -1 pour sens négatif, 0 pour pas de rotation

    float currentDiscRotationX;
    float angleRemaining;
    float currentFrameRotationDirection;

    [Space(10)]
    [Header("Disc Rotation Parameters")]
    public int numberOfSymbolsOnDisc = 39;
    public int debugSelectedSliceIndex = 0;
    public Color sliceLineColor = Color.cyan;
    public Color centerLineColor = Color.yellow;
    public float debugLineLength = 2f;

    void Start()
    {
        ModulesSequencing();
    }

    void Update()
    {
        if (isLocking == true)
        {
            ChevronLockingProcess();
        }
        if (discRotating)
        {
            RotateDiscToTargetAngle();
        }
    }

    public void OnManualGlyphEntered()
    {
        if (isStatic == false)
            return;
        if (discRotating == true || seqValidated == true)
            return;
        if (ChevronLockingSequenceSucces == false)
            return;

        isStatic = false;
        canClose = true;

        isLocking = true;
    }

    public void OnDhdGlyphClic(int glyphnum)
    {
        if (seqValidated == true)
            return;
        if (ChevronLockingSequenceSucces == false)
            return;

        isLocking = false;
        lockChevron = false;

        discIndex = glyphnum;

        RotationCalculus();

        currentDiscRotationX = disc.transform.localEulerAngles.x;
        angleRemaining = Mathf.DeltaAngle(currentDiscRotationX, targetDiscRotationX);
        currentFrameRotationDirection = Mathf.Sign(angleRemaining);

        if (isStatic == true)
            discRotating = false;
        else
            discRotating = true;

        canClose = true;

        //isLocking = true;

        ChevronSound(true);
    }

    public void OnKeyPressed(GameObject go)
    {
        if (seqValidated == true)
            return;
        if (ChevronLockingSequenceSucces == false)
            return;

        Image imageComp = go.GetComponent<Image>();
        Material mat = Instantiate(imageComp.material);
        mat.SetColor("_Color0", ActivatedKey * 10);
        imageComp.material = mat;
    }

    public void OnResetKeyboard()
    {
        foreach (GameObject k in Keys)
        {
            Image imageComp = k.GetComponent<Image>();
            Material mat = Instantiate(imageComp.material);
            mat.SetColor("_Color0", DesactivatedKey * 2);
            imageComp.material = mat;
        }
    }

    void ModulesSequencing()
    {
        chevronsS7 = new GameObject[_chevrons.Length - 2];
        lightsS7 = new GameObject[_lights.Length - 2];

        chevronsS8 = new GameObject[_chevrons.Length - 1];
        lightsS8 = new GameObject[_lights.Length - 1];

        chevronsS9 = new GameObject[_chevrons.Length];
        lightsS9 = new GameObject[_lights.Length];

        chevrons = new GameObject[chevronsS7.Length];
        chevrons = chevronsS7;

        lights = new GameObject[lightsS7.Length];
        lights = lightsS7;

        for (int i = 0; i < chevronsS7.Length; i++)
        {
            chevronsS7[i] = _chevrons[i];
        }

        for (int i = 0; i < lightsS7.Length; i++)
        {
            lightsS7[i] = _lights[i];
        }

        chevronsS8[0] = _chevrons[0];
        chevronsS8[1] = _chevrons[1];
        chevronsS8[2] = _chevrons[2];
        chevronsS8[3] = _chevrons[3];
        chevronsS8[4] = _chevrons[4];
        chevronsS8[5] = _chevrons[5];
        chevronsS8[6] = _chevrons[7];
        chevronsS8[7] = _chevrons[6];

        chevronsS9[0] = _chevrons[0];
        chevronsS9[1] = _chevrons[1];
        chevronsS9[2] = _chevrons[2];
        chevronsS9[3] = _chevrons[3];
        chevronsS9[4] = _chevrons[4];
        chevronsS9[5] = _chevrons[5];
        chevronsS9[6] = _chevrons[7];
        chevronsS9[7] = _chevrons[8];
        chevronsS9[8] = _chevrons[6];

        lightsS8[0] = _lights[0];
        lightsS8[1] = _lights[1];
        lightsS8[2] = _lights[2];
        lightsS8[3] = _lights[3];
        lightsS8[4] = _lights[4];
        lightsS8[5] = _lights[5];
        lightsS8[6] = _lights[7];
        lightsS8[7] = _lights[6];

        lightsS9[0] = _lights[0];
        lightsS9[1] = _lights[1];
        lightsS9[2] = _lights[2];
        lightsS9[3] = _lights[3];
        lightsS9[4] = _lights[4];
        lightsS9[5] = _lights[5];
        lightsS9[6] = _lights[7];
        lightsS9[7] = _lights[8];
        lightsS9[8] = _lights[6];
    }

    public void ChevronSound(bool dhd)
    {
        if (dhd == false)
            PlaySound(Random.Range(0, 2), false);
        else
            PlaySound(Random.Range(9, 15), false);
    }

    public void ChevronLockingProcess()
    {
        if (lockChevron == true)
        {
            if (chevrons[sequence].transform.GetChild(1).localPosition.y > 3.95f)
            {
                chevrons[sequence].transform.GetChild(1).localPosition = new Vector3(0, Mathf.Lerp(chevrons[sequence].transform.GetChild(1).localPosition.y, 3.95f, Time.deltaTime * 4), 0);
                ActivateLight();
            }
            if (chevrons[sequence].transform.GetChild(1).localPosition.y <= 3.96f)
            {
                unlockChevron = true;
                lockChevron = false;
            }
        }

        if (unlockChevron == true)
        {
            chevrons[sequence].transform.GetChild(1).localPosition = new Vector3(0, Mathf.Lerp(chevrons[sequence].transform.GetChild(1).localPosition.y, 4.1f, Time.deltaTime * 4), 0);

            if (chevrons[sequence].transform.GetChild(1).localPosition.y >= 4.09f)
            {
                ActivateChevron();
                unlockChevron = false;
            }
        }
    }

    public void PlaySound(int n, bool looped)
    {
        if (soundObject != null)
        {
            return;
        }
        soundObject = Instantiate(soundPrefab, transform);
        AudioSource loopsource = soundObject.GetComponent<AudioSource>();
        loopsource.clip = audioClip[n];
        loopsource.Play();

        Destroy(soundObject, loopsource.clip.length);
    }

    public void PlayParallelSound(int n, bool looped)
    {
        if (parallelSoundObject != null)
        {
            return;
        }
        parallelSoundObject = Instantiate(soundPrefab, transform);
        AudioSource loopsource = parallelSoundObject.GetComponent<AudioSource>();
        loopsource.clip = audioClip[n];
        loopsource.Play();

        Destroy(parallelSoundObject, loopsource.clip.length);
    }

    public void StopSound()
    {
        if (soundObject == null) { return; }
        Destroy(soundObject, 0.0f);
        soundObject = null;
    }

    public void ForceChevronStep()
    {
        ChevronLockingSequenceSucces = false;

        lockChevron = true;

        StopSound();
    }

    public void ActivateChevron()
    {
        if (sequence != chevrons.Length)
        {
            sequence++;
        }

        ChevronLockingSequenceSucces = true;

        /*if (sequence == chevrons.Length)
        {
            ActivateVortex();
        }*/
    }

    public void ActivateLight()
    {
        _lights[sequence].gameObject.SetActive(true);
    }

    public void OnForceActivation()
    {
        _lights[0].gameObject.SetActive(true);
        _lights[1].gameObject.SetActive(true);
        _lights[2].gameObject.SetActive(true);
        _lights[3].gameObject.SetActive(true);
        _lights[4].gameObject.SetActive(true);
        _lights[5].gameObject.SetActive(true);
        _lights[6].gameObject.SetActive(true);

        ActivateVortex();

        unlockChevron = false;
        sequence = chevrons.Length;
        canClose = true;
    }

    public void ActivateVortex()
    {
        StopSound();

        PlaySound(4, false);

        if (irisOpen == true)
        {
            kawoosh.SetActive(false);
            vortexLight.SetActive(false);
        }
        else
        {
            kawoosh.SetActive(true);
            vortexLight.SetActive(true);
        }

        vortexObject.GetComponent<Animation>().clip = anim[0];
        vortexObject.GetComponent<Animation>().Play();

        seqValidated = true;
        canClose = false;

        StartCoroutine(Chrono(anim[0].length));
    }

    IEnumerator Chrono(float len)
    {
        yield return new WaitForSeconds(len);

        canClose = true;
    }

    public void CloseDoor()
    {
        if (canClose == false)
            return;

        StopSound();

        PlaySound(5, false);

        vortexObject.GetComponent<Animation>().clip = anim[1];
        vortexObject.GetComponent<Animation>().Play();

        StartCoroutine(Chrono2(anim[0].length));
    }

    public void ForceCloseDoor()
    {
        StopSound();

        PlaySound(5, false);

        vortexObject.GetComponent<Animation>().clip = anim[1];
        vortexObject.GetComponent<Animation>().Play();

        StartCoroutine(Chrono2(anim[0].length));
    }

    IEnumerator Chrono2(float len)
    {
        yield return new WaitForSeconds(len);

        DesactivateDoor();
    }

    public void DesactivateDoor()
    {
        foreach (GameObject go in _lights)
        {
            go.SetActive(false);
        }
        seqValidated = false;
        canClose = false;
        OnResetKeyboard();
        sequence = 0;

        kawoosh.SetActive(false);
        vortexLight.SetActive(false);
    }

    public void ActivateIris()
    {
        if (irisMoving == false)
        {
            if (irisOpen == true)
            {
                transform.GetComponent<Animation>().clip = anim[2];
                transform.GetComponent<Animation>().Play();

                PlayParallelSound(7, false);

                StartCoroutine(IrisEnum(anim[2].length));
            }
            if (irisOpen == false)
            {
                transform.GetComponent<Animation>().clip = anim[3];
                transform.GetComponent<Animation>().Play();

                PlayParallelSound(8, false);

                StartCoroutine(IrisEnum(anim[3].length));
            }
            irisMoving = true;
        }
    }

    IEnumerator IrisEnum(float len)
    {
        yield return new WaitForSeconds(len);

        irisMoving = false;
        irisOpen = !irisOpen;

        if (seqValidated == true)
            if (irisOpen == true)
            {
                kawoosh.SetActive(false);
                vortexLight.SetActive(false);
            }
            else
            {
                kawoosh.SetActive(true);
                vortexLight.SetActive(true);
            }
    }

    public void ActivateGenerator()
    {
        activGen = !activGen;

        if (activGen)
        {
            activEPPZ = false;

            chevrons = new GameObject[chevronsS8.Length];
            chevrons = chevronsS8;

            lights = new GameObject[lightsS8.Length];
            lights = lightsS8;
        }
        else
        {
            chevrons = new GameObject[chevronsS7.Length];
            chevrons = chevronsS7;

            lights = new GameObject[lightsS7.Length];
            lights = lightsS7;
        }
    }

    public void ActivateEPPZ()
    {
        activEPPZ = !activEPPZ;

        if (activEPPZ)
        {
            activGen = false;

            chevrons = new GameObject[chevronsS9.Length];
            chevrons = chevronsS9;

            lights = new GameObject[lightsS9.Length];
            lights = lightsS9;
        }
        else
        {
            chevrons = new GameObject[chevronsS7.Length];
            chevrons = chevronsS7;

            lights = new GameObject[lightsS7.Length];
            lights = lightsS7;
        }
    }

    public void RotationCalculus()
    {
        float anglePerSlice = 360f / numberOfSymbolsOnDisc;
        float desiredAngleForSymbolUp = -(discIndex * anglePerSlice);

        targetDiscRotationX = WrapAngle(desiredAngleForSymbolUp);

        float currentDiscRotationX = disc.transform.localEulerAngles.x;
        float angleRemainingAtStart = Mathf.DeltaAngle(currentDiscRotationX, targetDiscRotationX);

        rotationDirection = Mathf.RoundToInt(Mathf.Sign(angleRemainingAtStart));

        if (Mathf.Abs(angleRemainingAtStart) < float.Epsilon)
        {
            rotationDirection = 0;
        }
    }

    public void RotateDiscToTargetAngle()
    {
        float step = discSpeed * Time.deltaTime;
        currentDiscRotationX = disc.transform.localEulerAngles.x;
        angleRemaining = Mathf.DeltaAngle(currentDiscRotationX, targetDiscRotationX);

        if (angleRemaining <= rotationStopTolerance && currentFrameRotationDirection == 1 || 
            angleRemaining >= rotationStopTolerance && currentFrameRotationDirection == -1)
        {
            discRotating = false;
            isLocking = true;
            lockChevron = true;

            StopSound();
        }
        else
            disc.transform.Rotate(currentFrameRotationDirection * step, 0, 0, Space.Self);
    }

    float WrapAngle(float angle)
    {
        angle %= 360f;
        if (angle > 180f)
        {
            return angle - 360f;
        }
        if (angle < -180f)
        {
            return angle + 360f;
        }
        return angle;
    }

    /*void OnDrawGizmosSelected()
    {
        if (disc == null)
        {
            disc = this.gameObject;
            if (disc == null) return;
        }

        Gizmos.matrix = disc.transform.localToWorldMatrix;

        Gizmos.color = Color.red;
        Gizmos.DrawRay(Vector3.zero, Vector3.right * debugLineLength);

        Gizmos.color = Color.green;
        Gizmos.DrawRay(Vector3.zero, Vector3.up * debugLineLength);

        float anglePerSlice = 360f / numberOfSymbolsOnDisc;

        for (int i = 0; i < numberOfSymbolsOnDisc; i++)
        {
            Gizmos.color = sliceLineColor;

            float startAngle = i * anglePerSlice;
            Quaternion rotation = Quaternion.Euler(startAngle, 0, 0);
            Vector3 direction = rotation * Vector3.up;

            Gizmos.DrawRay(Vector3.zero, direction * debugLineLength);
        }

        if (debugSelectedSliceIndex >= 0 && debugSelectedSliceIndex < numberOfSymbolsOnDisc)
        {
            Gizmos.color = centerLineColor;
            float centerAngle = debugSelectedSliceIndex * anglePerSlice;
            Quaternion centerRotation = Quaternion.Euler(centerAngle, 0, 0);
            Vector3 centerDirection = centerRotation * Vector3.up;

            Gizmos.DrawRay(Vector3.zero, centerDirection * debugLineLength * 1.2f);
        }
    }*/
}