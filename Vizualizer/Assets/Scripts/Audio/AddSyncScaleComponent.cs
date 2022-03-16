using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AddSyncScaleComponent : MonoBehaviour
{
    public GameObject[] Objects;
    public AudioSyncScale audioSyncScale;
    public float maxFreq = 25.0f;

    // Start is called before the first frame update
    void Start()
    {
        for (int i = 0; i < Objects.Length; i++)
        {
            Objects[i].AddComponent<AudioSyncScale>();
            AudioSyncScale ass = Objects[i].GetComponent<AudioSyncScale>();

            ass.bias = (i + 1) * maxFreq / Objects.Length;
            ass.timeStep = audioSyncScale.timeStep;
            ass.timeToBeat = audioSyncScale.timeToBeat;
            ass.restSmoothTime = audioSyncScale.restSmoothTime;
            ass.beatScale = audioSyncScale.beatScale;
            ass.restScale = audioSyncScale.restScale;
        }
    }
}
