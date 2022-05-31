using UnityEngine;
using Photon.Pun;
using Photon.Realtime;
using System.Collections;

public class multi_Fire : MonoBehaviourPunCallbacks
{
    public GameObject[] objectsList;
    public PhotonView PV;
    public float fireTimeLength = 1.0f;
    bool firing = false;

    private void Start()
    {
        StartCoroutine(FireTime());
    }

    void Update()
    {
        if (Input.GetMouseButton(0))
        {
            /*if(StartCoroutine(MaintainFire()) != null)
            {
                StopCoroutine(MaintainFire());
            }*/

            MaintainFire();
        }
        else
        {
            StartCoroutine(StopFireTime());
        }
    }

    void LocalFire()
    {
        foreach (GameObject o in objectsList)
        {
            o.SetActive(true);
        }
    }

    void LocalUnFire()
    {
        foreach (GameObject o in objectsList)
        {
            o.SetActive(false);
        }
    }

    [PunRPC]
    void SetFire(GameObject objs, PhotonMessageInfo info)
    {
        foreach (GameObject o in objectsList)
        {
            o.SetActive(true);
        }
    }

    [PunRPC]
    void StopFire(GameObject objs, PhotonMessageInfo info)
    {
        foreach (GameObject o in objectsList)
        {
            o.SetActive(false);
        }
    }

    void MaintainFire()
    {
        if (firing == true)
        {
            if (PV != null)
                PV.RPC("SetFire", RpcTarget.AllViaServer, objectsList);
            LocalFire();
        }
    }

    void DisableFire()
    {
        if (firing != true)
        {
            if (PV != null)
                PV.RPC("StopFire", RpcTarget.AllViaServer, objectsList);
            LocalUnFire();
        }
    }

    IEnumerator FireTime()
    {
        yield return new WaitForSeconds(fireTimeLength);
        firing = !firing;
    }

    IEnumerator StopFireTime()
    {
        yield return new WaitForSeconds(fireTimeLength);

        DisableFire();
    }
}
