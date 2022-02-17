using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class sc_Drawline : MonoBehaviour
{
    [SerializeField] private Transform _transformOne;
    [SerializeField] private Transform _transformTwo;
    LineRenderer lr;

    // Start is called before the first frame update
    void Start()
    {
        lr = GetComponent<LineRenderer>();
        if (lr.enabled == false)
        {
            lr.enabled = true;
        }
    }

    // Update is called once per frame
    void Update()
    {
        lr.SetPosition(0, _transformOne.position);
        lr.SetPosition(1, _transformTwo.position);
    }
}
