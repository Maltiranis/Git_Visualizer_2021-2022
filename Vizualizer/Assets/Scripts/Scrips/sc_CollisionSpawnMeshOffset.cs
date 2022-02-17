using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class sc_CollisionSpawnMeshOffset : MonoBehaviour
{
    public GameObject _itemToInstantiate;
    public Transform _mainCamera;
    public Vector3 _spawnOffset;
    public Vector3 _aimOffset;
    public float _throwForce = 1.0f;

    void Start()
    {
        
    }

    void Update()
    {
        if(Input.GetMouseButtonDown(0))
        {
            Ray ray = Camera.main.ScreenPointToRay(Input.mousePosition);
            RaycastHit hit;
            if (Physics.Raycast(ray, out hit, 100))
            {
                Vector3 hitPoint = hit.point;
                Vector3 spawnPoint = new Vector3
                (
                    hitPoint.x + _aimOffset.x,
                    hitPoint.y + _aimOffset.y,
                    hitPoint.z + _aimOffset.z
                );

                Vector3 dir = spawnPoint - _mainCamera.position;

                //Debug.Log(hit.transform.name);
                GameObject rock = Instantiate(_itemToInstantiate, Camera.main.transform.position + _spawnOffset, Quaternion.identity);
                rock.GetComponent<Rigidbody>().AddForce(dir * _throwForce,ForceMode.Impulse);
            }
        }
    }
}
