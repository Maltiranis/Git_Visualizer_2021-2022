using UnityEngine;
using Photon.Pun;
using Photon.Realtime;
using System.Collections;

public class multi_Fire : MonoBehaviourPunCallbacks
{
    public GameObject[] missileSpawners;
    public GameObject missilePrefab;
    public float missileSpeed = 10.0f;
    public float missileoffset = 1.0f;

    public PhotonView PV;

    private void Start()
    {
        //StartCoroutine(FireTime());
    }

    void Update()
    {
        if (PV.IsMine)
            if (Input.GetMouseButtonDown(0))
            {
                photonView.RPC("LocalFire", RpcTarget.All);
            }
    }

    [PunRPC]
    void LocalFire()
    {
        foreach (GameObject o in missileSpawners)
        {
            Vector3 spawnPos = o.transform.position + o.transform.forward * missileoffset;
            GameObject missile = PhotonNetwork.Instantiate(missilePrefab.name, spawnPos, transform.rotation);
            missile.GetComponent<Rigidbody>().AddForce(transform.forward * missileSpeed);
        }
    }
}
