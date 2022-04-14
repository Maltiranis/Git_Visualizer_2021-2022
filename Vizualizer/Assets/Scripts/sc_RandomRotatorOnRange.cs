using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class sc_RandomRotatorOnRange : MonoBehaviour
{
    public float lookatSpeed = 2.0f;

    [Header("Limits")]
    public float xLeft = 45.0f;
    public float xRight = -45.0f;
    public float yUp = 0.0f;
    public float yDown = -45.0f;

    float rotationX;
    float rotationY;


    Quaternion toRotation;

    void Start()
    {
        StartCoroutine(ChangeRotation());
    }

    void Update()
    {
        transform.rotation = Quaternion.Lerp(transform.rotation, toRotation, Time.deltaTime * lookatSpeed);
    }

    float randomizeChanger(float changeRotMin, float changeRotMax)
    {
        return Random.Range(changeRotMin, changeRotMax);
    }

    IEnumerator ChangeRotation()
    {
        yield return new WaitForSeconds(Random.Range(1,3));

        rotationX = randomizeChanger(xLeft, xRight);
        rotationY = randomizeChanger(yUp, yDown);

        rotationX = Mathf.Clamp(transform.rotation.x, xLeft, xRight);
        rotationY = Mathf.Clamp(transform.rotation.y, yUp, yDown);

        toRotation = Quaternion.Euler(rotationX, rotationY, 0);
        StartCoroutine(ChangeRotation());
    }
}
