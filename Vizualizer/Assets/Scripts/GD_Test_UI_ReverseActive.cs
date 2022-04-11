using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GD_Test_UI_ReverseActive : MonoBehaviour
{
    public GameObject[] toReverseList;
    //public string _name = "ShipsButtons";
    GameObject namedGo;

    public void ReverseActive()
    {
        foreach (GameObject go in toReverseList)
        {
            go.SetActive(!go.activeSelf);
        }
    }

    public void DisableByName(string _name)
    {
        if (namedGo == null)
            namedGo = GameObject.Find(_name);
        if (namedGo != null)
            namedGo.SetActive(!namedGo.activeSelf);
    }
}
