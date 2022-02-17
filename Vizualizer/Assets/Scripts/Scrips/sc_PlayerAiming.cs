using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class sc_PlayerAiming : MonoBehaviour
{
    Animator anim;
    public float step = 0.1f;
    float _blendState = 0.0f;
    float blendSign = -1.0f;

    private void Start()
    {
        anim = GetComponent<Animator>();
        StartCoroutine(blendState());
    }

    void Update()
    {
        if (Input.GetMouseButtonDown(1))
        {
            blendSign = 1;
        }
        if (Input.GetMouseButtonUp(1))
        {
            blendSign = -1;
        }

        anim.SetFloat("aimingBlend", _blendState);
    }

    IEnumerator blendState()
    {
        yield return new WaitForSeconds(step);

        if (_blendState <= 0)
            _blendState = 0;
        if (_blendState >= 0.1f)
            _blendState = 0.1f;

        _blendState += step * blendSign;

        StartCoroutine(blendState());
    }
}
