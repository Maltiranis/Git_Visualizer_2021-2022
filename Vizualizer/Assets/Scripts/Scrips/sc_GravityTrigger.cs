using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class sc_GravityTrigger : MonoBehaviour
{
    [SerializeField] private float _gravityForce;
    [SerializeField] List<GameObject> _inGravity = new List<GameObject>();

    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        foreach(GameObject g in _inGravity)
        {
            Vector3 dir = transform.position - g.transform.position;
            if (g.GetComponent<Rigidbody>() != null)
            {
                Rigidbody rb = g.GetComponent<Rigidbody>();
                rb.AddForce(dir.normalized * _gravityForce, ForceMode.Acceleration);
            }
        }
    }

    private void OnTriggerStay(Collider other)
    {
        if (!_inGravity.Contains(other.gameObject) && other.gameObject.GetComponent<Rigidbody>() != null)
            _inGravity.Add(other.gameObject);
    }

    private void OnTriggerExit(Collider other)
    {
        if (_inGravity.Contains(other.gameObject))
            _inGravity.Remove(other.gameObject);
    }
}
