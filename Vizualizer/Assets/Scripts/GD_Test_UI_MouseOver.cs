using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.EventSystems;

public class GD_Test_UI_MouseOver : MonoBehaviour, IPointerEnterHandler, IPointerExitHandler
{
    public GameObject showMeOnMouseHover;

    public void OnPointerEnter(PointerEventData eventData)
    {
        showMeOnMouseHover.SetActive(true);
    }

    public void OnPointerExit(PointerEventData eventData)
    {
        showMeOnMouseHover.SetActive(false);
    }
}
