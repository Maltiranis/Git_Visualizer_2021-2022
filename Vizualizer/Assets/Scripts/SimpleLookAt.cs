using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SimpleLookAt : MonoBehaviour
{
    //public bool _fromVelocity = true;
    public Transform looked;
    public float speed = 2.0f;
    public float rotSpeed = 10.0f;

    float brassage = 0.0f;

    private void Start()
    {
        StartCoroutine(rotationPilot());
    }

    void Update()
    {
        /*Vector3 direction;

        Vector3 offsetedPos = new Vector3(looked.position.x, looked.position.y, transform.position.z);
        direction = offsetedPos - transform.position;


        Quaternion toRotation = Quaternion.FromToRotation(transform.forward, -direction);
        transform.rotation = Quaternion.Lerp(transform.rotation, toRotation, speed * Time.deltaTime);*/

        Vector3 targetPos = looked.position - transform.position;
        //targetPos.z = transform.forward.z;
        transform.forward = Vector3.Lerp(transform.forward, -targetPos, speed * Time.deltaTime);

        transform.GetChild(0).Rotate(transform.GetChild(0).forward, rotSpeed * brassage * Time.deltaTime, Space.World);
    }

    IEnumerator rotationPilot()
    {
        float rotNow = Random.Range(.5f, 2.0f);

        brassage = Random.Range(-2.0f, 2.0f);

        yield return new WaitForSeconds(rotNow);
        StartCoroutine(rotationPilot());
    }
}
