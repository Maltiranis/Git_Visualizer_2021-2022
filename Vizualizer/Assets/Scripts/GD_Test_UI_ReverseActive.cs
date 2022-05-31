using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GD_Test_UI_ReverseActive : MonoBehaviour
{
    public GameObject[] toReverseList;
    //public string _name = "ShipsButtons";
    GameObject newGo;
    public string objName;

    private void OnEnable()
    {
        newGo = GameObject.Find(objName);

        if (newGo != null)
            newGo.SetActive(false);
    }

    public void ReverseActive()
    {
        foreach (GameObject go in toReverseList)
        {
            if (go != null)
                go.SetActive(!go.activeSelf);
        }
    }

    public void DisableByName()
    {
        if (newGo == null)
        {
            newGo = GameObject.Find(objName);
        }
        newGo.SetActive(!newGo.activeSelf);
    }
}
