using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DestroyTimer : MonoBehaviour
{
    public float timer = 2.0f;

    void Start()
    {
        Destroy(gameObject, timer);
    }
}
