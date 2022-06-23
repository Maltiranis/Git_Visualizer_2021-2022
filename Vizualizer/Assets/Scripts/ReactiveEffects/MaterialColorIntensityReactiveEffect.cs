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

        public float MinIntensity;
        public float IntensityScale;
        public float MinEmissionIntensity;
        public float EmissionIntensityScale;

        #endregion

        #region Startup / Shutdown

        private void Awake()
        {
            if (this.transform.childCount > 0)
                this.transform.GetChild(0).gameObject.GetComponent<Renderer>().material = Instantiate(Resources.Load("NeonMat") as Material);
            else
                this.gameObject.GetComponent<Renderer>().material = Instantiate(Resources.Load("SphereMat") as Material);
        }

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

        #region Render

        public void Update()
        {
            float audioData = GetAudioData();
            float scaledEmissionAmount;
            //float scaledAmount = Mathf.Clamp(MinIntensity + (audioData * IntensityScale), 0.0f, 10.0f);

            if (!fromScale)
                scaledEmissionAmount = Mathf.Clamp(MinEmissionIntensity + (audioData * EmissionIntensityScale), 0.0f, 100.0f);
            else
                scaledEmissionAmount = (transform.localScale.x + transform.localScale.y + transform.localScale.z) * (transform.localScale.x + transform.localScale.y + transform.localScale.z) / 5;

            Color scaledColor = _initialColor * scaledEmissionAmount;
            Color scaledEmissionColor = _initialEmissionColor * scaledEmissionAmount;
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