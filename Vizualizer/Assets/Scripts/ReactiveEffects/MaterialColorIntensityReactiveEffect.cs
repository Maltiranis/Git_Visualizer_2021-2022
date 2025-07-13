using Assets.Scripts.ReactiveEffects.Base;
using UnityEngine;

namespace Assets.Scripts.ReactiveEffects
{
    public class MaterialColorIntensityReactiveEffect : VisualizationEffectBase
    {
        #region Private Member Variables

        private Renderer _renderer;
        public Color _initialColor;
        public Color _initialEmissionColor;
        public int matIndex = 0;
        public bool fromScale = false;

        #endregion

        #region Public Properties

        public bool RGB_method = true;
        public float MinIntensity;
        public float IntensityScale;
        public float MinEmissionIntensity;
        public float EmissionIntensityScale;

        #endregion

        #region Startup / Shutdown

        /*private void Awake()
        {
            if (this.transform.childCount > 0)
                this.transform.GetChild(0).gameObject.GetComponent<Renderer>().material = Instantiate(Resources.Load("NeonMat") as Material);
            else
                this.gameObject.GetComponent<Renderer>().material = Instantiate(Resources.Load("SphereMat") as Material);
        }*/

        public override void Start()
        {
            base.Start();

            if (this.transform.childCount > 0)
            {
                _renderer = this.transform.GetChild(0).gameObject.GetComponent<Renderer>();
                _initialColor = this.transform.GetChild(0).gameObject.GetComponent<Renderer>().material.GetColor("_Color");
                _initialEmissionColor = this.transform.GetChild(0).gameObject.GetComponent<Renderer>().material.GetColor("_EmissionColor");
            }
            else
            {
                _renderer = this.gameObject.GetComponent<Renderer>();
                _initialColor = this.gameObject.GetComponent<Renderer>().material.GetColor("_Color");
                _initialEmissionColor = this.gameObject.GetComponent<Renderer>().material.GetColor("_EmissionColor");
            }
        }

        #endregion

        public Color GetGradientColor(int index, int totalItems)
        {
            // Calcule la position normalisée (de 0.0 à 1.0) sur le gradient
            // On divise par (totalItems - 1) pour s'assurer que le dernier objet (index = totalItems - 1) reçoive bien la couleur de fin (valeur 1.0)
            float t = (float)index / (totalItems - 1);

            // Le gradient a deux parties : Rouge -> Vert (pour t de 0.0 à 0.5) et Vert -> Bleu (pour t de 0.5 à 1.0)
            if (t < 0.5f)
            {
                // Interpole entre le rouge et le vert
                // On remet t à l'échelle de 0.0-1.0 pour cette moitié de gradient (en multipliant par 2)
                return Color.Lerp(Color.red, Color.green, t * 2);
            }
            else
            {
                // Interpole entre le vert et le bleu
                // On remet t à l'échelle de 0.0-1.0 pour cette deuxième moitié (en soustrayant 0.5 puis en multipliant par 2)
                return Color.Lerp(Color.green, Color.blue, (t - 0.5f) * 2);
            }
        }

        int GetMyPosition()
        {
            for (int i = 0; i < transform.parent.childCount; i++)
            {
                if (transform.parent.GetChild(i) == this.transform)
                    return i;
            }
            return 0;
        }

        int GetTotalItems()
        {
            return transform.parent.childCount;
        }

        #region Render

        public void Update()
        {
            float audioData = GetAudioData();
            float scaledEmissionAmount;
            //float scaledAmount = Mathf.Clamp(MinIntensity + (audioData * IntensityScale), 0.0f, 10.0f);

            if (!fromScale)
                scaledEmissionAmount = Mathf.Clamp(MinEmissionIntensity + (audioData * EmissionIntensityScale), 0.0f, 100.0f);
            else
                scaledEmissionAmount = ((transform.localScale.x + transform.localScale.y + transform.localScale.z) * audioData * EmissionIntensityScale) / 5;

            Color scaledColor = _initialColor * scaledEmissionAmount;
            Color scaledEmissionColor = _initialEmissionColor * scaledEmissionAmount;

            if (RGB_method)
            {
                scaledColor = GetGradientColor(GetMyPosition(), GetTotalItems()) * scaledEmissionAmount;
                scaledEmissionColor = GetGradientColor(GetMyPosition(), GetTotalItems()) * scaledEmissionAmount;
            }

            //scaledColor.a = scaledColor.r;

            //this.gameObject.GetComponent<Renderer>().material.SetColor("_Color", scaledColor);
            if (this.transform.childCount > 0)
            {
                this.transform.GetChild(0).gameObject.GetComponent<Renderer>().materials[matIndex].SetColor("_Color", scaledColor);//  * scaledColor);
                this.transform.GetChild(0).gameObject.GetComponent<Renderer>().materials[matIndex].SetColor("_EmissionColor", scaledEmissionColor);//  * scaledEmissionColor);
            }
            else
            {
                this.gameObject.GetComponent<Renderer>().materials[matIndex].SetColor("_Color", scaledColor);//  * scaledColor);
                this.gameObject.GetComponent<Renderer>().materials[matIndex].SetColor("_EmissionColor", scaledEmissionColor);// * scaledEmissionColor);
            }
        }

        #endregion

        #region Public Methods

        public void UpdateColor(Color color)
        {
            _initialColor = color;
            _initialEmissionColor = color;
        }

        #endregion
    }
}