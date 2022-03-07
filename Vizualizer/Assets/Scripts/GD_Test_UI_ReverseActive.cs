using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GD_Test_UI_ReverseActive : MonoBehaviour
{
    public GameObject[] toReverseList;

    public void ReverseActive()
    {
        foreach (GameObject go in toReverseList)
        {
            go.SetActive(!go.activeSelf);
        }
    }
}
