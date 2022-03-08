using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SimpleFollow : MonoBehaviour
{
    public Transform toFollow;
    public float speed = 2.0f;

    void Update()
    {
        Vector3 toF = toFollow.position;

        this.transform.position = Vector3.Lerp(transform.position, toF, speed * Time.deltaTime);
    }
}
