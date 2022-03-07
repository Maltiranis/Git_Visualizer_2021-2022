using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GD_Test_UI_ActiveOnEnable : MonoBehaviour
{
    public GameObject[] toActiveOnEnable;
    public GameObject[] toDesactiveOnEnable;
    public GameObject[] toReactiveOnDisable;

    void OnEnable()
    {
        foreach (GameObject go in toActiveOnEnable)
        {
            go.SetActive(true);
        }
        foreach (GameObject go in toDesactiveOnEnable)
        {
            go.SetActive(false);
        }
    }

    void OnDisable()
    {
        foreach (GameObject go in toActiveOnEnable)
        {
            go.SetActive(false);
        }
        foreach (GameObject go in toReactiveOnDisable)
        {
            go.SetActive(true);
        }
    }
}
