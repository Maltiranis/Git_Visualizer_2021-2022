using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Photon.Pun;
using System.IO;
using TMPro;

public class PhotonTchat : MonoBehaviour
{
    public PhotonView PV;
    public GameObject dialPrefab;
    public TMP_InputField inputField;

    public GameObject content;

    void Start()
    {
        if (!PV.IsMine)
        {
            //GameObject.Find("TCHAT").SetActive(false);
        }
    }

    void Update()
    {
        
    }

    public void MyOnValidateText()
    {
        if (PV == null)
            return;

        if (GameObject.FindGameObjectWithTag("CONTENT") != null)
            content = GameObject.FindGameObjectWithTag("CONTENT");

        //PV.RPC("SayIt", RpcTarget.All);

        string inputText = PV.Owner.NickName + " : " + inputField.text;

        GameObject newText = (GameObject)Instantiate
        (
            dialPrefab,
            content.transform.position,
            content.transform.rotation
        );

        newText.GetComponentInChildren<TMP_Text>().text = inputText;

        newText.transform.parent = content.transform;
        newText.transform.localScale = Vector3.one;

        PV.RPC("SayIt", RpcTarget.AllViaServer, newText, inputText);
        //PV.RPC("SayIt", RpcTarget.All);
    }

    [PunRPC]
    void SayIt(PhotonMessageInfo info, GameObject newText, string inputText)
    {
        GameObject cloneText = Instantiate
        (
            newText,
            newText.transform.position,
            newText.transform.rotation
        );

        cloneText.transform.parent = content.transform;
        cloneText.GetComponentInChildren<TMP_Text>().text = inputText;
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
