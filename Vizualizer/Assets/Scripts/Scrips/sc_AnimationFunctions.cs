using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class sc_AnimationFunctions : MonoBehaviour
{
    public float _lerpingFrom = 1f;
    public float _lerpingTo = 0f;
    public float _lerpingValue = 1f;
    public float _lerpingSpeed = 0.1f;
    public Material m;
    Material newM;

    // Start is called before the first frame update
    void Start()
    {
        _lerpingValue = _lerpingFrom;
        newM = gameObject.GetComponent<Renderer>().material;
        gameObject.GetComponent<Projector>().material = newM;
        m = newM;
    }

    // Update is called once per frame
    void Update()
    {
        _lerpingValue = Mathf.Lerp(_lerpingValue, _lerpingTo, _lerpingSpeed * Time.smoothDeltaTime);

        if (m != null)
        {
            newM.SetFloat("_LerpValue", _lerpingValue);

            if (_lerpingValue == _lerpingTo)
            {
                Destroy(gameObject, 0.5f);
            }
        }
    }

    public void _CallDestruction()
    {
        Destroy(gameObject, 0f);
    }
}
