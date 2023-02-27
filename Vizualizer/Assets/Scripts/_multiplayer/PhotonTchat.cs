using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Photon.Pun;
using System.IO;
using TMPro;

public class PhotonTchat : MonoBehaviour
{
    public PhotonView PV;
    public GameObject content;
    //public GameObject photonText;
    public TMP_InputField inputField;


    void Start()
    {
        if (PV == null)
            return;

        gameObject.name = PV.Owner.NickName;
    }

    void Update()
    {
        
    }

    public void MyOnValidateText()
    {
        if (PV == null)
            return;

        if (PV.IsMine)
            PV.RPC("SayIt", RpcTarget.AllViaServer);
        else
        {
            transform.GetChild(0).gameObject.SetActive(false);
            PV.RPC("EarIt", RpcTarget.AllViaServer);

        }

        /*if (!PV.IsMine)
        {
            
        }
        else
            PV.RPC("SincSpeechs", RpcTarget.AllViaServer);*/


    }

    [PunRPC]
    void EarIt(PhotonMessageInfo info)
    {
        string inputText = PV.Owner.NickName + " : " + inputField.text;

        GameObject newText = PhotonNetwork.Instantiate
        (
            Path.Combine("PhotonPrefabs", "dialPrefab"),
            content.transform.position,
            content.transform.rotation
        );

        newText.GetComponentInChildren<TMP_Text>().text = inputText;

        newText.transform.parent = content.transform;
    }

    [PunRPC]
    void SayIt(PhotonMessageInfo info)
    {
        string inputText = PV.Owner.NickName + " : " + inputField.text;

        GameObject newText = PhotonNetwork.Instantiate
        (
            Path.Combine("PhotonPrefabs", "dialPrefab"),
            content.transform.position,
            content.transform.rotation
        );

        newText.GetComponentInChildren<TMP_Text>().text = inputText;

        newText.transform.parent = content.transform;
    }

    [PunRPC]
    void SincSpeechs(PhotonMessageInfo info)
    {
        
    }

    /*public void OnPhotonSerializeView(PhotonStream stream)
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
    }*/
}
