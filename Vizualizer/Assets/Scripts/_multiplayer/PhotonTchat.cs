using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Photon.Pun;

public class PhotonTchat : MonoBehaviour
{
    public PhotonView PV;
    public GameObject content;

    void Start()
    {
        if (PV == null)
            return;

        gameObject.name = PV.Owner.NickName;
    }

    void Update()
    {
        
    }

    public void OnPhotonSerializeView(PhotonStream stream)
    {
        if (PV == null)
            return;

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
