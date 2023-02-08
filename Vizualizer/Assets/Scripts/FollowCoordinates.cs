using Photon.Pun;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;

public class FollowCoordinates : MonoBehaviour
{
    public Transform target;
    public PhotonView PV;

    void Update()
    {
        if (PV == null)
            return;

        if (PhotonNetwork.IsMasterClient)
        {
            //PV.RPC("SayMyName", RpcTarget.AllBuffered, PV.Owner.NickName);
            gameObject.GetComponentInChildren<TextMeshProUGUI>().text = PV.Owner.NickName;
            gameObject.transform.position = target.position;
        }
        else
        {
            gameObject.transform.position = target.position;
        }
    }

    // coller ce truc partout : coller le bool du vaisseau actif + le nom du joueur
    public void OnPhotonSerializeView(PhotonStream stream)
    {
        if (PV == null)
            return;

        if (stream.IsWriting)
        {
            stream.SendNext(gameObject.GetComponentInChildren<TextMeshProUGUI>().text);
            stream.SendNext(gameObject.transform.position);
        }
        else
        {
            gameObject.GetComponentInChildren<TextMeshProUGUI>().text = (string)stream.ReceiveNext();
            gameObject.transform.position = (Vector3)stream.ReceiveNext();
        }
    }
}
