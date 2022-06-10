using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using TMPro;

public class ShapeOnSlider : MonoBehaviour
{
    public GameObject[] Objects;
    Slider slid;
    Vector3[] startScales;

    void Start()
    {
        slid = GetComponent<Slider>();
        startScales = new Vector3[Objects.Length];

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

    public void MyOnValueChanged ()
    {
        for (int i = 0; i < Objects.Length; i++)
        {
            if (Objects.Length > 0)
            {
                Objects[i].transform.localScale = startScales[i] + (slid.value * startScales[i]);
            }
        }
    }
}
