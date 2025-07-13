using Assets.Scripts.ReactiveEffects.Base;
using UnityEngine;

namespace Assets.Scripts.ReactiveEffects
{
    public class ObjectScaleReactiveEffect : VisualizationEffectBase
    {
        #region Private Member Variables

        private Vector3 _initialScale;
        private Vector3 _initialPos;

        #endregion

        #region Public Properties

        public Vector3 ScaleIntensity;

        #endregion

        #region Startup / Shutdown

        public override void Start()
        {
            base.Start();

            _initialScale = Vector3.one;
            _initialPos = transform.localPosition;
        }

        #endregion

        #region Render

        public void Update()
        {
            float audioData = GetAudioData();
            float xScaleAmount = audioData * ScaleIntensity.x;
            float yScaleAmount = audioData * ScaleIntensity.y;
            float zScaleAmount = audioData * ScaleIntensity.z;
            gameObject.transform.localScale = _initialScale + new Vector3(xScaleAmount, yScaleAmount, zScaleAmount);
            gameObject.transform.localPosition = _initialPos + new Vector3(xScaleAmount / 2, yScaleAmount / 2, zScaleAmount / 2);
        }

        #endregion
    }
}