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
    public GameObject TchatPrefab;
    //public GameObject photonText;
    public TMP_InputField inputField;

    public GameObject[] ContentsArray; // TAG TOUT LES CONTENT du UI et COLLE LES TOUS L� AVEC UN GAMEOBJECT.FIND + TU INSTANCIE LES PHRASE DANS TOUS !!!


    void Start()
    {
        if (PV == null)
            return;

        if (!PV.IsMine)
        {
            gameObject.SetActive(false);
        }

        gameObject.name = PV.Owner.NickName + "Tchat";
    }

    void Update()
    {
        
    }

    public void MyOnValidateText()
    {
        if (PV == null)
            return;

        PV.RPC("SayIt", RpcTarget.AllViaServer);
    }

    [PunRPC]
    void SayIt(PhotonMessageInfo info)
    {
        string inputText = PV.Owner.NickName + " : " + inputField.text;

        GameObject newText = (GameObject)Instantiate
        (
            TchatPrefab,
            content.transform.position,
            content.transform.rotation
        );

        newText.GetComponentInChildren<TMP_Text>().text = inputText;

        newText.transform.parent = content.transform;
        newText.transform.localScale = Vector3.one;
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
