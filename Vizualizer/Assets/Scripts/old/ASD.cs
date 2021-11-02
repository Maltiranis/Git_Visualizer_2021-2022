using UnityEngine;
using System.Collections;
using System.Collections.Generic;


public class ASD : MonoBehaviour
{
    public int numberOfObjects = 40;
    public GameObject[] cubes;

    public float juice = 150; //150f;

    // Use this for initialization
    void Start()
    {
        Application.targetFrameRate = 999;
    }

    // Update is called once per frame
    private void Update()
    {
        float[] spectrum = AudioListener.GetSpectrumData(1024, 0, FFTWindow.Hamming);
        for (int i = 0; i < numberOfObjects; i++)
        {
            Vector3 previousScale = cubes[i].transform.localScale;
            previousScale.y = Mathf.Lerp(previousScale.y, spectrum[i] * juice, Time.deltaTime * 30);
            cubes[i].transform.localScale = previousScale;
        }
    }
}