using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using TMPro;

public class ChangeEmSlider : MonoBehaviour
{
    public Slider slidR;
    public Slider slidG;
    public Slider slidB;
    public Slider slidX;

    Renderer renderer;
    Material mat;

    void Start()
    {
        renderer = GetComponent<Renderer>();
        mat = renderer.material;
    }

    void Update()
    {
        renderer = GetComponent<Renderer>();
        mat = renderer.material;

        Color baseColor = new Color(slidR.value, slidG.value, slidB.value);

        mat.SetColor("_EmissionColor", baseColor * slidX.value);
    }
}
