using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class sc_DebugPlayerUGUI : MonoBehaviour
{
    void OnDrawGizmosSelected()
    {
        Gizmos.color = Color.blue;

        Vector3 position = new Vector3
        (
            transform.position.x,
            transform.position.y + 1.0f,
            transform.position.z
        );

        Vector3 direction = transform.TransformDirection(Vector3.forward) * 5;
        Gizmos.DrawRay(position, direction);
    }
}
