using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FollowCoordinates : MonoBehaviour
{
    public Transform target;

    void Update()
    {
        transform.position = target.position;
    }
}
