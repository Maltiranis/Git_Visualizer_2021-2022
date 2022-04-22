using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class sc_RandomRotatorOnRange : MonoBehaviour
{
    [Header("Aiming")]
    public float lookatSpeed = 2.0f;
    public float minTime = 2.0f;
    public float maxTime = 4.0f;
    [Header("Parent")]
    public Transform _parent;
    [Header("Limits")]
    public float yLeft = 45.0f;
    public float yRight = -45.0f;
    public float xUp = 0.0f;
    public float xDown = -45.0f;

    float rotationX;
    float rotationY;


    Quaternion startRotation;
    Quaternion toRotation;

    bool coroutRunning = false;

    void Start()
    {
        //transform.rotation = new Quaternion(_parent.transform.localRotation.x + xUp, _parent.transform.localRotation.y + yLeft, _parent.transform.localRotation.z, _parent.transform.localRotation.w);
        startRotation = _parent.transform.localRotation;

        StartCoroutine(ChangeRotation());
    }

    private void OnEnable()
    {
        if (coroutRunning == false)
        {
            StartCoroutine(ChangeRotation());
        }
    }

    private void OnDisable()
    {
        StopCoroutine(ChangeRotation());
        coroutRunning = false;
    }

    void Update()
    {
        transform.localRotation = Quaternion.Lerp(transform.localRotation, toRotation, Mathf.Clamp(Time.deltaTime * lookatSpeed, 0f, 0.99f));
    }

    float randomizeChanger(float changeRotMin, float changeRotMax)
    {
        return Random.Range(changeRotMin, changeRotMax);
    }

    IEnumerator ChangeRotation()
    {
        coroutRunning = true;
        yield return new WaitForSeconds(Random.Range(minTime, maxTime));

        rotationY = randomizeChanger(startRotation.y + yLeft, startRotation.y + yRight);
        rotationX = randomizeChanger(startRotation.x + xUp, startRotation.x + xDown);

        toRotation = Quaternion.Euler(rotationX, rotationY, 0);
        coroutRunning = false;
        StartCoroutine(ChangeRotation());
    }
}
