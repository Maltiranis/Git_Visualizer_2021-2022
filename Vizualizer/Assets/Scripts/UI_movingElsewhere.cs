using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.EventSystems;

public class UI_movingElsewhere : MonoBehaviour, IPointerEnterHandler, IPointerExitHandler
{
    //public bool activator = true;
    //public GameObject toActivate;
    public float posOffset = -9.5f;
    Vector2 position1;
    Vector2 position2;
    bool isIn = false;
    /*[Header("require meshrenderer in Child(0)")]
    public Material mat1;
    public Material mat2;*/

    public float transitionTime = 0.2f;
    float timeElapsed = 0.0f;
    RectTransform rect;

    public void OnPointerEnter(PointerEventData eventData)
    {
        isIn = true;
        timeElapsed = 0.0f;
    }
    public void OnPointerExit(PointerEventData eventData)
    {

    }

    private void Start()
    {
        rect = GetComponent<RectTransform>();
        position1 = new Vector2(rect.anchoredPosition.x, rect.anchoredPosition.y);
        position2 = new Vector2(rect.anchoredPosition.x, posOffset);
    }

    void Update()
    {
        Deploy();
        //ClickAction();
        //ChangeMatIfActif();
    }

    #region Deployment
    void Deploy()
    {
        if (isIn && rect.anchoredPosition != position2)
        {
            MoveFunction(position1, position2);
        }
        if (!isIn && rect.anchoredPosition != position1)
        {
            MoveFunction(position2, position1);
        }

        if (timeElapsed > 5.0f)
        {
            isIn = false;
            timeElapsed = 0.0f;
        }
    }

    private void MoveFunction(Vector2 from, Vector2 to)
    {
        if (timeElapsed < transitionTime)
        {
            transform.position = Vector2.Lerp(from, to, timeElapsed / transitionTime);
        }
        timeElapsed += Time.deltaTime;
    }
    #endregion Deployment

    /*#region Clic
    private void ClickAction()
    {
        if (Input.GetMouseButtonDown(0) && isIn)
        {
            if (activator)
            {
                if (toActivate != null)
                    toActivate.SetActive(!toActivate.activeInHierarchy);
            }
        }
    }
    #endregion Clic

    #region ChangeMat
    private void ChangeMatIfActif() //require meshrenderer in Child(0)
    {
        if (mat1 != null && mat2 != null)
        {
            if (toActivate.activeInHierarchy)
            {
                transform.GetChild(0).GetComponent<Renderer>().material = mat2;
            }
            else
            {
                transform.GetChild(0).GetComponent<Renderer>().material = mat1;
            }
        }
    }
    #endregion ChangeMat*/
}
