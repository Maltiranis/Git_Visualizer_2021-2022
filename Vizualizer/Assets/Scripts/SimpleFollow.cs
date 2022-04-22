using Photon.Pun;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SimpleFollow : MonoBehaviour
{
    public Transform toFollow;
    public float speed = 2.0f;
    //public float stopRange = 1.0f;

    public PhotonView PV;

    void Update()
    {
        //float dist = Vector3.Distance(transform.position, toFollow.position);
        //if (stopRange < dist)
            transform.position = Vector3.Lerp(transform.position, toFollow.position, Time.deltaTime * speed);
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
