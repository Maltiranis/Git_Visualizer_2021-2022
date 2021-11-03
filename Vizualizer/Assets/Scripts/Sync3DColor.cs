using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Sync3DColor : MonoBehaviour
{
    public Color myColor = Color.white;

    void Update()
    {
        gameObject.GetComponent<Renderer>().material.color = myColor;
    }
}
