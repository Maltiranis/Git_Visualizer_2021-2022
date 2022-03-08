using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FollowMouse : MonoBehaviour
{
    public GameObject myCam;
    public float offsetZ = 10.0f;
    public float speed = 2.0f;
    public bool instantaneous = false;

    void Start()
    {
        
    }

   void Update ()
    {
        Vector3 temp = Input.mousePosition;
        temp.z = offsetZ;

        if (instantaneous == false)
            this.transform.position = Vector3.Lerp(transform.position, myCam.GetComponent<Camera>().ScreenToWorldPoint(temp), speed * Time.deltaTime);
        else
            this.transform.position = Camera.main.ScreenToWorldPoint(temp);
    }
}
