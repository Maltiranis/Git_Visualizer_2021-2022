using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Assets.Scripts.Audio;
using Assets.Scripts.ReactiveEffects.Base;
using Assets.Scripts.ReactiveEffects;

public class _audio_SetMyIdentityOnList : MonoBehaviour
{
    public bool reverseID = false;

    public GameObject barsContainer;

    public GameObject[] containers;

    public List<GameObject> barList = new List<GameObject>();
    public GameObject[] _bars;

    VisualizationEffectBase veb;
    MaterialColorIntensityReactiveEffect mire;
    ObjectScaleReactiveEffect osre;

    //AudioSampleIndex

    private void Awake()
    {
        SetID();
    }

    public void ReverseID ()
    {
        reverseID = !reverseID;
        SetID();
    }

    public void SetID ()
    {
        barList.Clear();

        containers = new GameObject[barsContainer.transform.childCount];

        if (!reverseID)
        {
            for (int i = 0; i < containers.Length; i++)
            {
                containers[i] = barsContainer.transform.GetChild(i).gameObject;
            }

            for (int i = 0; i < containers.Length; i++)
            {
                for (int j = 0; j < containers[i].transform.childCount; j++)
                {
                    barList.Add(containers[i].transform.GetChild(j).gameObject);

                    GameObject actualBar = containers[i].transform.GetChild(j).gameObject;

                    actualBar.GetComponent<ObjectScaleReactiveEffect>().AudioSampleIndex = i;
                    actualBar.GetComponent<MaterialColorIntensityReactiveEffect>().AudioSampleIndex = i;
                }
            }
        }
        else
        {
            for (int i = containers.Length - 1; i >= 0; i--)
            {
                containers[i] = barsContainer.transform.GetChild(i).gameObject;
            }

            for (int i = containers.Length - 1; i >= 0; i--)
            {
                for (int j = 0; j < containers[i].transform.childCount; j++)
                {
                    barList.Add(containers[i].transform.GetChild(j).gameObject);

                    GameObject actualBar = containers[i].transform.GetChild(j).gameObject;

                    actualBar.GetComponent<ObjectScaleReactiveEffect>().AudioSampleIndex = i;
                    actualBar.GetComponent<MaterialColorIntensityReactiveEffect>().AudioSampleIndex = i;
                }
            }
        }
        _bars = barList.ToArray();
    }
}
