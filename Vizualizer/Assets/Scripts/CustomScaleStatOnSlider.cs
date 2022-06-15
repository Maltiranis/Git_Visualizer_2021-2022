using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class CustomScaleStatOnSlider : MonoBehaviour
{
    public Slider slidF;

    [HideInInspector]
    public GameObject[] _bars;

    private void Start ()
    {
        SetBars();
    }

    public void SetBars ()
    {
        _bars = GetComponent<_audio_SetMyIdentityOnList>()._bars;
    }

    void Update()
    {
        for (int i = 0; i < _bars.Length; i++)
        {
            Vector3 force = _bars[i].GetComponent<Assets.Scripts.ReactiveEffects.ObjectScaleReactiveEffect>().ScaleIntensity;

            if (force.x != 0)
                _bars[i].GetComponent<Assets.Scripts.ReactiveEffects.ObjectScaleReactiveEffect>().ScaleIntensity.x = slidF.value;
            if (force.y != 0)
                _bars[i].GetComponent<Assets.Scripts.ReactiveEffects.ObjectScaleReactiveEffect>().ScaleIntensity.y = slidF.value;
            if (force.z != 0)
                _bars[i].GetComponent<Assets.Scripts.ReactiveEffects.ObjectScaleReactiveEffect>().ScaleIntensity.z = slidF.value;
        }
    }
}
