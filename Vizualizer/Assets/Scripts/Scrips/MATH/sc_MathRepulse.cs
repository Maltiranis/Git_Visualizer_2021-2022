using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class sc_MathRepulse : MonoBehaviour
{
    public float _speedForce = 10f;
    public float _repulseForce = 20f;
    public float _minProximityDist = 1f;
    public float _rotationForce = 1f;

    Rigidbody rb;
    GameObject[] others;
    public GameObject _reachGoal;

    // Start is called before the first frame update
    void Start()
    {
        rb = GetComponent<Rigidbody>();
        others = GameObject.FindGameObjectsWithTag("Player");
    }

    // Update is called once per frame
    void Update()
    {
        Vector3 dir = (_reachGoal.transform.position - transform.position).normalized;

        transform.GetChild(0).LookAt(_reachGoal.transform);
        transform.rotation = Quaternion.Lerp(transform.rotation, transform.GetChild(0).rotation, _rotationForce * Time.deltaTime);

        rb.velocity = new Vector3(dir.x * _speedForce, dir.y * _speedForce, dir.z * _speedForce);

        foreach (var o in others)
        {
            float dist = Vector3.Distance(o.transform.position, transform.position);
            if (dist < _minProximityDist)
            {
                Vector3 invDir = (o.transform.position - transform.position).normalized;
                rb.AddForce(-invDir * _repulseForce, ForceMode.Force);
            }
        }
    }
}
