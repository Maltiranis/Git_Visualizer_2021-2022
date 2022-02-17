using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class sc_Projectile : MonoBehaviour
{
    [SerializeField] private float _lifeTime = 10f;
    [SerializeField] private float _corectSpeed = 10f;
    [SerializeField] private float _minDist = 25f;
    public int _team = 0;
    public float _damages = 10f;
    [SerializeField] private GameObject _damagePrefab;
    float launchedTimer = 0f;

    [HideInInspector]
    public Transform target;

    // Start is called before the first frame update
    void Start()
    {
        Destroy(gameObject, _lifeTime);
    }

    // Update is called once per frame
    void Update()
    {
        launchedTimer += Time.deltaTime * _corectSpeed;

        if (target != null)
        {
            float dist = Vector3.Distance(target.position, transform.position);
            Vector3 dir = target.position - transform.position;

            //transform.LookAt(target.position);
            if (dist < _minDist)
            {
                GetComponent<Rigidbody>().velocity = dir.normalized * launchedTimer * 10;
            }
            //GetComponent<Rigidbody>().AddForce(transform.forward * cor * 10, ForceMode.Acceleration);
            GetComponent<Rigidbody>().velocity = dir.normalized * launchedTimer;
        }
    }

    private void OnTriggerEnter(Collider other)
    {
        if (other.gameObject.GetComponent<sc_LifeEngine>() != null && other.gameObject.GetComponent<sc_LifeEngine>()._team != _team)
        {
            other.gameObject.GetComponent<sc_LifeEngine>().TakeDamage(_damages);

            //Vector3 dir = other.transform.position - transform.position;
            //Vector3 dirNorm = dir.normalized;
            Vector3 point = transform.position;

            if (_damagePrefab != null)
            {
                GameObject projectil = Instantiate(_damagePrefab, point, Quaternion.identity);
                projectil.transform.parent = other.transform;
                projectil.transform.LookAt(other.gameObject.transform);
            }
            
            Destroy(gameObject, 0f);
        }
    }
}
