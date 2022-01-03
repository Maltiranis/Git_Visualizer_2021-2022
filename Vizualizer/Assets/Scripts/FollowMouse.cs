using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FollowMouse : MonoBehaviour
{
    public float offsetZ = 10.0f;
    public float speed = 2.0f;

    void Start()
    {
        
    }

   void Update ()
    {
        Vector3 temp = Input.mousePosition;
        temp.z = offsetZ;

        this.transform.position = Vector3.Lerp(transform.position, Camera.main.ScreenToWorldPoint(temp), speed * Time.deltaTime);
    }
}
