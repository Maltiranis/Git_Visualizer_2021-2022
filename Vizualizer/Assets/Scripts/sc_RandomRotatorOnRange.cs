using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class sc_RandomRotatorOnRange : MonoBehaviour
{
    public float lookatSpeed = 2.0f;

    [Header("Limits")]
    public float yLeft = 45.0f;
    public float yRight = -45.0f;
    public float xUp = 0.0f;
    public float xDown = -45.0f;

    float rotationX;
    float rotationY;


    Quaternion startRotation;
    Quaternion toRotation;

    void Start()
    {
        transform.rotation = new Quaternion(transform.rotation.x + 360f, transform.rotation.y + 360f, transform.rotation.z + 360f, transform.rotation.w);
        startRotation = transform.rotation;

        StartCoroutine(ChangeRotation());
    }

    void Update()
    {
        transform.rotation = Quaternion.Lerp((Quaternion)transform.rotation, (Quaternion)toRotation, (float)Time.deltaTime * (float)lookatSpeed + 0.001f);
    }

    float randomizeChanger(float changeRotMin, float changeRotMax)
    {
        return Random.Range(changeRotMin, changeRotMax);
    }

    IEnumerator ChangeRotation()
    {
        yield return new WaitForSeconds(Random.Range(1,3));

        rotationY = randomizeChanger(startRotation.y + yLeft, startRotation.y + yRight);
        rotationX = randomizeChanger(startRotation.x + xUp, startRotation.x + xDown);

        toRotation = Quaternion.Euler(rotationX, rotationY, 0);
        StartCoroutine(ChangeRotation());
    }
}
