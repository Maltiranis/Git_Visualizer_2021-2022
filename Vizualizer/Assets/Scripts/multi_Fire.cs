using UnityEngine;
using Photon.Pun;
using Photon.Realtime;
using System.Collections;

public class multi_Fire : MonoBehaviourPunCallbacks
{
    public GameObject[] objectsList;
    public PhotonView PV;
    public float fireTimeLength = 1.0f;

    void Update()
    {
        if (Input.GetMouseButtonDown(0))
        {
            /*if(StartCoroutine(MaintainFire()) != null)
            {
                StopCoroutine(MaintainFire());
            }*/

            StartCoroutine(MaintainFire());
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

    IEnumerator MaintainFire()
    {
        PV.RPC("SetFire", RpcTarget.AllViaServer, objectsList);
        LocalFire();

        yield return new WaitForSeconds(fireTimeLength);

        PV.RPC("StopFire", RpcTarget.AllViaServer, objectsList);
        LocalUnFire();
    }
}
