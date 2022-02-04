using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class OpacitySlider : MonoBehaviour
{
    [Header("Put this script on the UI-Slider")]
    public GameObject ObjContainingAlpha;
    Material mat;
    Slider slide;

    void Start()
    {
        slide = GetComponent<Slider>();
        mat = ObjContainingAlpha.GetComponent<Renderer>().material;

    }

    void Update()
    {
        OnValueChanged();
    }

    void OnValueChanged ()
    {
        Color newC = new Color(0, 0, 0, slide.value);
        mat.SetColor("_Color", newC);
    }
}
