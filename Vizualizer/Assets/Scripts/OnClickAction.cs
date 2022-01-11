using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class OnClickAction : MonoBehaviour
{
    public bool activator = true;
    public GameObject toActivate;
    public Vector3 position1;
    public Vector3 position2;
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
        Deploy();
        ClickAction();
        ChangeMatIfActif();
    }

    #region Deployment
    void Deploy()
    {
        if (isIn)
        {
            MoveFunction(position2);
        }
        if (!isIn)
        {
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
        isIn = true;
        timeElapsed = 0.0f;
    }

    private void OnTriggerExit2D(Collider2D other)
    {
        isIn = false;
        timeElapsed = 0.0f;
    }
}
