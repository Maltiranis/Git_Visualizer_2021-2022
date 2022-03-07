using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GD_Test_UI_MultiEnabler : MonoBehaviour
{
    public GameObject[] toActivateList;
    public GameObject[] toDesactivateList;

    public void ActiveThem()
    {
        foreach (GameObject go in toActivateList)
        {
            go.SetActive(true);
        }
    }

    public void DesactiveThem()
    {
        foreach (GameObject go in toDesactivateList)
        {
            go.SetActive(false);
        }
    }

    public void DoBothFunctions ()
    {
        ActiveThem();
        DesactiveThem();
    }
}
