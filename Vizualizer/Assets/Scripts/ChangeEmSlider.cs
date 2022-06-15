using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using TMPro;
using Assets.Scripts.ReactiveEffects.Base;

public class ChangeEmSlider : MonoBehaviour
{
    public Slider slidR;
    public Slider slidG;
    public Slider slidB;
    public Slider slidX;

    [HideInInspector]
    public GameObject[] _bars;

    private void Start()
    {
        SetBars();
    }

    public void SetBars()
    {
        _bars = GetComponent<_audio_SetMyIdentityOnList>()._bars;
    }

    void Update()
    {
        for (int i = 0; i < _bars.Length; i++)
        {
            //Renderer renderer = _bars[i].GetComponent<Renderer>();
            //Material mat = renderer.material;

            Color baseColor = new Color(slidR.value, slidG.value, slidB.value);

            //mat.SetColor("_EmissionColor", baseColor * slidX.value);
            _bars[i].GetComponent<Assets.Scripts.ReactiveEffects.MaterialColorIntensityReactiveEffect>()._initialEmissionColor = baseColor * slidX.value;
        }
    }
}
