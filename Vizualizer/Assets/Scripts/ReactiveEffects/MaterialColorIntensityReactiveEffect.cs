using Assets.Scripts.ReactiveEffects.Base;
using UnityEngine;

namespace Assets.Scripts.ReactiveEffects
{
    public class MaterialColorIntensityReactiveEffect : VisualizationEffectBase
    {
        #region Private Member Variables

        private Renderer _renderer;
        private Color _initialColor;
        public Color _initialEmissionColor;

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
            this.transform.GetChild(0).gameObject.GetComponent<Renderer>().material = Instantiate(Resources.Load("NeonMat") as Material);
        }

        public override void Start()
        {
            base.Start();

            _renderer = this.transform.GetChild(0).gameObject.GetComponent<Renderer>();
            _initialColor = this.transform.GetChild(0).gameObject.GetComponent<Renderer>().material.GetColor("_Color");
            _initialEmissionColor = this.transform.GetChild(0).gameObject.GetComponent<Renderer>().material.GetColor("_EmissionColor");
        }

        #endregion

        #region Render

        public void Update()
        {
            float audioData = GetAudioData();
            float scaledAmount = Mathf.Clamp(MinIntensity + (audioData * IntensityScale), 0.0f, 10.0f);
            float scaledEmissionAmount = Mathf.Clamp(MinEmissionIntensity + (audioData * EmissionIntensityScale), 0.0f, 100.0f);
            //Color scaledColor = _initialColor * scaledAmount;
            Color scaledEmissionColor = _initialEmissionColor * scaledEmissionAmount;
            //scaledColor.a = scaledColor.r;

            //this.gameObject.GetComponent<Renderer>().material.SetColor("_Color", scaledColor);
            this.transform.GetChild(0).gameObject.GetComponent<Renderer>().material.SetColor("_EmissionColor", scaledEmissionColor * scaledEmissionColor);
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