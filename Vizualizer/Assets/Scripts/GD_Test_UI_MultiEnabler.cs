using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Photon.Pun;
using TMPro;

public class GD_Test_UI_MultiEnabler : MonoBehaviour
{
    [SerializeField]
    public GameObject[] objectsList;
    public PhotonView PV;
    public GameObject nameHolder;

    private void Start()
    {
        //PV = GetComponent<PhotonView>();
        PV.RPC("SayMyName", RpcTarget.AllViaServer, PV.Owner.NickName);

        if (!PV.IsMine)
        {
            transform.GetChild(0).gameObject.SetActive(false);
        }
        else
        PV.RPC("SyncShips", RpcTarget.AllViaServer);
    }

    [PunRPC]
    void SyncShips(PhotonMessageInfo info)
    {
        for (int i = 0; i < objectsList.Length; i++)
        {
            if (objectsList[i] != null)
            objectsList[i].SetActive(objectsList[i].activeSelf);
        }
    }

    [PunRPC]
    void SayMyName(string myName, PhotonMessageInfo info)
    {
        nameHolder.GetComponent<TextMeshProUGUI>().text = myName;
    }

    public void ActiveThisOne(int thisOne)
    {
        PV.RPC("SyncActivated", RpcTarget.AllViaServer, thisOne);
    }

    [PunRPC]
    void SyncActivated(int tO, PhotonMessageInfo info)
    {
        for (int i = 0; i < objectsList.Length; i++)
        {
            objectsList[i].SetActive(false);
        }
        objectsList[tO].SetActive(true);
    }
}
