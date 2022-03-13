using Photon.Pun;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SimpleFollow : MonoBehaviour
{
    public Transform toFollow;
    public float speed = 2.0f;
    public PhotonView PV;

    void Update()
    {
        transform.position = Vector3.Lerp(transform.position, toFollow.position, Time.fixedDeltaTime * speed);
    }

    public void OnPhotonSerializeView(PhotonStream stream, PhotonMessageInfo info)
    {
        if (stream.IsWriting)
        {
            stream.SendNext(transform.position);
        }
        else
        {
            transform.position = (Vector3)stream.ReceiveNext();
        }
    }
}
