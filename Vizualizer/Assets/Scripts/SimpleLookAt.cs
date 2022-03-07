using FishNet.Object;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SimpleLookAt : NetworkBehaviour
{
    //public bool _fromVelocity = true;
    public bool rotateInertia = true;
    public Transform looked;
    public float lookatSpeed = 2.0f;
    public float rotSpeed = 10.0f;
    public Vector2 rotTimeRange;
    public Vector2 rotSpeedRange;

    float brassage = 0.0f;

    private void Start()
    {
        if (!base.IsOwner)
            return;

        StartCoroutine(rotationPilot());
    }

    void Update()
    {
        if (!base.IsOwner)
            return;

        if (!rotateInertia)
        {
            Quaternion toRotation = Quaternion.LookRotation(transform.position - looked.position, transform.up);

            transform.rotation = Quaternion.Lerp(transform.rotation, toRotation, Time.deltaTime * lookatSpeed);
            transform.GetChild(0).Rotate(transform.GetChild(0).forward, rotSpeed * brassage * Time.deltaTime, Space.World);
        }
        else
        {
            Vector3 myPos = transform.position;
            Vector3 curPos = looked.position;

            Vector3 relativePos = curPos - myPos;
            Vector3 addVectors = (relativePos - transform.forward) + Vector3.forward/4;

            Quaternion toRotation = Quaternion.LookRotation(-relativePos, -addVectors);
            transform.rotation = Quaternion.Lerp(transform.rotation, toRotation, Time.deltaTime * lookatSpeed);
            //transform.GetChild(0).Rotate(transform.GetChild(0).forward, rotSpeed * brassage * Time.deltaTime, Space.World);
        }
    }

    IEnumerator rotationPilot()
    {
        float rotNow = Random.Range(.5f, 2.0f);

        brassage = Random.Range(-2.0f, 2.0f);

        yield return new WaitForSeconds(rotNow);
        StartCoroutine(rotationPilot());
    }
}
