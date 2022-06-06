using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GD_Test_UI_ReverseActive : MonoBehaviour
{
    public GameObject[] toReverseList;
    //public string _name = "ShipsButtons";
    GameObject newGo;
    public string objName;
    Animator animtr;

    bool isActive = false;

    private void OnEnable()
    {
        newGo = GameObject.Find(objName);

        if (newGo != null)
            newGo.SetActive(isActive);

        foreach (GameObject go in toReverseList)
        {
            if (go != null)
            {
                go.SetActive(isActive);
            }
        }

        if (GetComponent<Animator>() != null)
        {
            animtr = GetComponent<Animator>();
        }
    }

    public void ReverseActive()
    {
        foreach (GameObject go in toReverseList)
        {
            if (go != null)
            {
                isActive = !isActive;
                go.SetActive(isActive);
            }
        }

        if (newGo != null)
            newGo.SetActive(isActive);

        if (animtr != null)
            animtr.SetBool("Activated", isActive);
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
