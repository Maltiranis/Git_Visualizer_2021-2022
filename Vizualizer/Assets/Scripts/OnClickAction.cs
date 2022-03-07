using FishNet.Object;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class OnClickAction : NetworkBehaviour
{
    public bool activator = true;
    public GameObject toActivate;
    public float xStart = -11.625f;
    public float xEnd = -9.5f;
    Vector3 position1;
    Vector3 position2;
    bool isIn = false;
    public Material mat1;
    public Material mat2;

    public float transitionTime = 0.2f;
    float timeElapsed = 0.0f;

    void Start()
    {
        
    }

    void Update()
    {
        if (!base.IsOwner)
            return;

        Deploy();
        ClickAction();
        ChangeMatIfActif();
    }

    #region Deployment
    void Deploy()
    {
        if (isIn)
        {
            position2 = new Vector3(xEnd, transform.position.y, transform.position.z);
            MoveFunction(position2);
        }
        if (!isIn)
        {
            position1 = new Vector3(xStart, transform.position.y, transform.position.z);
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
                    toActivate.SetActive(!toActivate.activeInHierarchy);
            }
        }
    }
    #endregion Clic

    #region ChangeMat
    private void ChangeMatIfActif () //require meshrenderer in Child(0)
    {
        if (mat1 != null && mat2 != null)
        {
            if(toActivate.activeInHierarchy)
            {
                transform.GetChild(0).GetComponent<Renderer>().material = mat2;
            }
            else
            {
                transform.GetChild(0).GetComponent<Renderer>().material = mat1;
            }
        }
    }
    #endregion ChangeMat

    private void OnTriggerEnter2D(Collider2D other)
    {
        if (!base.IsOwner)
            return;

        isIn = true;
        timeElapsed = 0.0f;
    }

    private void OnTriggerExit2D(Collider2D other)
    {
        if (!base.IsOwner)
            return;

        isIn = false;
        timeElapsed = 0.0f;
    }
}
