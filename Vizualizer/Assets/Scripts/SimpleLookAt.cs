using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SimpleLookAt : MonoBehaviour
{
    public Transform looked;
    public float speed = 2.0f;

    void Update()
    {
        Vector3 direction = looked.position - transform.position;

        Quaternion toRotation = Quaternion.FromToRotation(transform.forward, -direction);
        transform.rotation = Quaternion.Lerp(transform.rotation, toRotation, speed * Time.deltaTime );
    }
}
