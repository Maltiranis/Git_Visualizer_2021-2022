
using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;
using UnityEngine.EventSystems;
using UnityEngine.Serialization;
using UnityEngine.UI;

public class OnClickAction : Selectable
{
    public bool activator = true;
    public GameObject toActivate;
    public float yStart = -11.625f;
    public float yEnd = -9.5f;
    Vector3 position1;
    Vector3 position2;
    bool isIn = false;
    public Material mat1;
    public Material mat2;

    public float transitionTime = 0.2f;
    float timeElapsed = 0.0f;

    [Serializable]
    public class ButtonClickedEvent : UnityEvent { }

    [FormerlySerializedAs("onClick")]
    [SerializeField]
    private ButtonClickedEvent m_OnClick = new ButtonClickedEvent();

    public ButtonClickedEvent onClick
    {
        get { return m_OnClick; }
        set { m_OnClick = value; }
    }

    void Update()
    {
        Deploy();
        ClickAction();
        ChangeMatIfActif();
    }

    #region Deployment
    void Deploy()
    {
        if (isIn)
        {
            position2 = new Vector3(transform.position.x, yEnd, transform.position.z);
            MoveFunction(position2);
        }
        if (!isIn)
        {
            position1 = new Vector3(transform.position.x, yStart, transform.position.z);
            MoveFunction(position1);
        }
    }

    private void MoveFunction(Vector3 destination)
    {
        if (timeElapsed < transitionTime)
        {
            transform.position = Vector3.Lerp(transform.position, destination, timeElapsed / transitionTime);
            timeElapsed += Time.deltaTime;
        }
    }
    #endregion Deployment

    #region Clic
    private void ClickAction()
    {
        if (Input.GetMouseButtonDown(0) && isIn)
        {
            if(activator)
            {
                if (toActivate != null)
                {
                    toActivate.SetActive(!toActivate.activeInHierarchy);
                }
            }
            if (!IsActive() || !IsInteractable())
                return;

            UISystemProfilerApi.AddMarker("Button.onClick", this);
            m_OnClick.Invoke();
        }
    }
    #endregion Clic

    #region ChangeMat
    private void ChangeMatIfActif () //require meshrenderer in Child(0)
    {
        if (mat1 != null && mat2 != null)
        {
            if (transform.GetChild(0).GetComponent<Renderer>().sharedMaterial == mat1)
            {
                transform.GetChild(0).GetComponent<Renderer>().sharedMaterial = mat2;
            }
            else
            {
                transform.GetChild(0).GetComponent<Renderer>().sharedMaterial = mat1;
            }
        }
    }
    #endregion ChangeMat

    private void OnTriggerEnter2D(Collider2D other)
    {
        isIn = true;
        timeElapsed = 0.0f;
    }

    private void OnTriggerExit2D(Collider2D other)
    {
        isIn = false;
        timeElapsed = 0.0f;
    }
}
