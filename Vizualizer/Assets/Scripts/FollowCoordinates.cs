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
        transform.position = target.position;
        if (PhotonNetwork.IsMasterClient)
        {
            //PV.RPC("SayMyName", RpcTarget.AllBuffered, PV.Owner.NickName);
            gameObject.GetComponentInChildren<TextMeshProUGUI>().text = PV.Owner.NickName;
        }
    }

    // coller ce truc partout : coller le bool du vaisseau actif + le nom du joueur
    public void OnPhotonSerializeView(PhotonStream stream)
    {
        if (stream.IsWriting)
        {
            stream.SendNext(gameObject.GetComponentInChildren<TextMeshProUGUI>().text);
        }
        else
        {
            gameObject.GetComponentInChildren<TextMeshProUGUI>().text = (string)stream.ReceiveNext();
        }
    }
}
