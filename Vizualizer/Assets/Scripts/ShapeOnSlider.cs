using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using TMPro;

public class ShapeOnSlider : MonoBehaviour
{
    [Header("Empty who is not used")]
    public GameObject[] Objects;
    public GameObject Object;

    [Space(5)]
    public Slider slid;

    [Space(5)]
    Vector3[] startScales;
    Vector3 startScale;

    void Start()
    {
        slid = GetComponent<Slider>();
        startScales = new Vector3[Objects.Length];
        startScale = new Vector3(slid.minValue, slid.minValue, slid.minValue);


        for (int i = 0; i < Objects.Length; i++)
        {
            startScales[i] = Objects[i].transform.localScale;
        }

        StartCoroutine(delayMe());
    }

    IEnumerator delayMe ()
    {
        yield return new WaitForSeconds(.1f);

        MyOnValueChanged();
    }

    public void MyOnMultipleValuesChanged ()
    {
        for (int i = 0; i < Objects.Length; i++)
        {
            if (Objects.Length > 0)
            {
                Objects[i].transform.localScale = startScales[i] + (slid.value * startScales[i]);
            }
        }
    }

    public void MyOnValueChanged()
    {
        Object.transform.localScale = startScale + (slid.value * startScale);
    }
}
