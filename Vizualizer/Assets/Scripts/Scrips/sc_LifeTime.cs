using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class sc_LifeTime : MonoBehaviour
{
    public float _life = 5.0f;

    void Start()
    {
        Destroy(gameObject, _life);
    }
}
