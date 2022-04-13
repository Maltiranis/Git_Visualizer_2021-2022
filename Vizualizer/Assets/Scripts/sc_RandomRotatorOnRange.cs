using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class sc_RandomRotatorOnRange : MonoBehaviour
{
    public Transform anglesContainer;

    public float lookatSpeed = 2.0f;
    public float changeRotMin = 1.0f;
    public float changeRotMax = 2.0f;

    Quaternion toRotation;

    void Start()
    {
        StartCoroutine(ChangeRotation());
    }

    void Update()
    {
        transform.GetChild(0).transform.rotation = Quaternion.Lerp(transform.rotation, toRotation, Time.deltaTime * lookatSpeed);
    }

    float randomizeChanger()
    {
        return Random.Range(changeRotMin, changeRotMax);
    }

    IEnumerator ChangeRotation()
    {
        yield return new WaitForSeconds(randomizeChanger());

        toRotation = anglesContainer.GetChild((int)Random.Range((int)0, (int)3)).rotation;
        StartCoroutine(ChangeRotation());
    }
}
