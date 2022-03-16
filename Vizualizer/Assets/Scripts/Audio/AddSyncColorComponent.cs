using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AddSyncColorComponent : MonoBehaviour
{
    public GameObject[] Objects;
    public float maxColor = 10.0f;
    public float colorIntens = 10.0f;
    public Color fromColor;
    public Color toColor;

    void Start()
    {
        for (int i = 0; i < Objects.Length; i++)
        {
            Objects[i].AddComponent<Sync3DColor>();
        }
    }

    private void Update()
    {
        for (int i = 0; i < Objects.Length; i++)
        {
            float scaleSum = (Objects[i].transform.localScale.x + Objects[i].transform.localScale.y + Objects[i].transform.localScale.z) - 3;
            Color newCol = Color.Lerp(fromColor, toColor, scaleSum / maxColor);

            Objects[i].GetComponent<Sync3DColor>().myColor = newCol * colorIntens;
        }
    }
}
