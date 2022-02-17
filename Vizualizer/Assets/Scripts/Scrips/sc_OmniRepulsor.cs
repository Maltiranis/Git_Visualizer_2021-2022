using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[RequireComponent(typeof(Rigidbody))]
public class sc_OmniRepulsor : MonoBehaviour
{
    [SerializeField] private float _repulsionForce;
    [SerializeField] private Transform[] _repulsors;
    [SerializeField] private float _rayLen = 10f;
    Vector3 _rayDir;

    private Rigidbody rb;

    // Start is called before the first frame update
    void Start()
    {
        rb = GetComponent<Rigidbody>();
    }

    // Update is called once per frame
    void Update()
    {
        Repulsing();
    }

    void Repulsing()
    {
        foreach (Transform r in _repulsors)
        {
            _rayDir = r.forward;
            CustomRaycast(r, _rayDir);
            Debug.DrawRay(r.position, _rayDir, Color.red);
        }
    }

    void CustomRaycast(Transform r, Vector3 newDir)
    {
        RaycastHit hit;
        if (Physics.Raycast(r.position, newDir, out hit, _rayLen))
        {
            float mult = Vector3.Distance(hit.point, r.position);
            float multNorm;
            if (mult >= 1)
            {
                multNorm = mult;
            }
            else
            {
                multNorm = 1;
            }

            rb.AddForce(-newDir * _repulsionForce * multNorm, ForceMode.Acceleration);
        }
    }
}
