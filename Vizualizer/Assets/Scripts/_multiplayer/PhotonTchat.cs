using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Photon.Pun;
using System.IO;
using TMPro;

public class PhotonTchat : MonoBehaviour
{
    public PhotonView PV;
    public GameObject TchatPrefab;
    tChatProfile tCP;

    void Start()
    {
        if (!PV.IsMine)
        {
            GameObject.Find("TCHAT").SetActive(false);
        }
    }

    void Update()
    {
        if (tCP.isSetted == true)
        {
            MyOnValidateText();
            tCP.isSetted = false;
        }
    }

    public void MyOnValidateText()
    {
        if (tCP == null)
            tCP = GameObject.FindGameObjectWithTag("TCHAT").GetComponent<tChatProfile>();
        if (tCP == null)
            tCP = GameObject.Find("TCHAT").GetComponent<tChatProfile>();

        if (PV == null)
            return;

        if (PV.IsMine)
        {
            if (tCP == null)
            {
                return;
            }

            string inputText = PV.Owner.NickName + " : " + tCP.inputField.text;

            GameObject newText = (GameObject)Instantiate
            (
                TchatPrefab,
                tCP.content.transform.position,
                tCP.content.transform.rotation
            );

            newText.GetComponentInChildren<TMP_Text>().text = inputText;

            newText.transform.parent = tCP.content.transform;
            newText.transform.localScale = Vector3.one;
        }
        else
            PV.RPC("SayIt", RpcTarget.AllViaServer);
    }

    [PunRPC]
    void SayIt(PhotonMessageInfo info)
    {
        tCP.content = GameObject.FindGameObjectWithTag("TCHAT");

        if (tCP == null)
        {
            return;
        }

        string inputText = PV.Owner.NickName + " : " + tCP.inputField.text;

        GameObject newText = (GameObject)Instantiate
        (
            TchatPrefab,
            tCP.content.transform.position,
            tCP.content.transform.rotation
        );

        newText.GetComponentInChildren<TMP_Text>().text = inputText;

        newText.transform.parent = tCP.content.transform;
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
