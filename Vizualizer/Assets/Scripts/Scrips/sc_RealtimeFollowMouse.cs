using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class sc_RealtimeFollowMouse : MonoBehaviour
{
    public Camera _cam;
    public float _speed = 1.0f;

    Vector3 spawnPoint;
    Ray ray;
    RaycastHit hit;

    void Start()
    {
        
    }

    void Update()
    {
        ray = _cam.ScreenPointToRay(Input.mousePosition);
        
        if (Physics.Raycast(ray, out hit, Mathf.Infinity))
        {
            Vector3 hitPoint = hit.point;
        }

        float dist = Vector3.Distance(transform.position, hit.point);

        if (dist != 0.0f && hit.point != Vector3.zero)
        {
            Vector3 follow = Vector3.Lerp(transform.position, hit.point, _speed / 100 / dist);
            transform.position = follow;
        }
        if (transform.position - hit.point != Vector3.zero)
            transform.forward = transform.position - hit.point;
    }
}
