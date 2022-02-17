using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class sc_Rotator : MonoBehaviour
{
    public Vector3 _axis;
    public float _angleSpeed;

    void Update()
    {
        DoRotate(_axis, _angleSpeed);
    }

    void DoRotate(Vector3 axis, float speed)
    {
        Vector3 angles = new Vector3
        (
            axis.x * Time.deltaTime * speed,
            axis.y * Time.deltaTime * speed,
            axis.z * Time.deltaTime * speed
        );

        transform.Rotate(angles, Space.Self);
    }
}
