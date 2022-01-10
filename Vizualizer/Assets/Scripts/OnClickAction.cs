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

    public float transitionTime = 0.2f;
    float timeElapsed = 0.0f;

    void Start()
    {
        
    }

    void Update()
    {
        Deploy();
        ClickAction();
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
