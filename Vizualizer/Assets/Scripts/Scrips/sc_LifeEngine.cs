using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class sc_LifeEngine : MonoBehaviour
{
    [SerializeField] private float _life = 100f;
    [SerializeField] private GameObject _owner;
    public int _team = 0;

    // Start is called before the first frame update
    void Start()
    {
        if (_owner == null)
            _owner = gameObject;
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    public void TakeDamage(float damages)
    {
        if (_life - damages > 0f)
            _life -= damages;
        else
            _life = 0f;

        if (_life <= 0f)
        {
            Desactivate();
        }
    }

    void Desactivate()
    {
        //_owner.SetActive(false);
    }
}
