using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class LookatCamera : MonoBehaviour
{
    public Transform target;
    public bool preferLookZaxis = true;

    void Update()
    {
        if (preferLookZaxis)
            transform.LookAt(Vector3.forward);
        else
            transform.LookAt(target);
    }
}
