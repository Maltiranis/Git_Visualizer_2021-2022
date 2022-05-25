using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Assets.Scripts.Audio;
using Assets.Scripts.ReactiveEffects.Base;
using Assets.Scripts.ReactiveEffects;

public class _audio_SetMyIdentityOnList : MonoBehaviour
{
    public GameObject[] VisualizerScriptContainer;

    VisualizationEffectBase veb;
    MaterialColorIntensityReactiveEffect mire;
    ObjectScaleReactiveEffect osre;

    //AudioSampleIndex

    void Start()
    {
        for (int i = 0; i < VisualizerScriptContainer.Length; i++)
        {
            VisualizerScriptContainer[i].GetComponent<ObjectScaleReactiveEffect>().AudioSampleIndex = i;
            VisualizerScriptContainer[i].GetComponent<MaterialColorIntensityReactiveEffect>().AudioSampleIndex = i;
        }
    }
}
