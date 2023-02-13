using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Photon.Pun;
using TMPro;
using Photon.Realtime;

public class GD_Test_UI_MultiEnabler : MonoBehaviourPunCallbacks
{
    [SerializeField]
    public GameObject[] objectsList;
    public PhotonView PV;
    public GameObject nameHolder;
    public GameObject Aiming;

    public int ship = 0;

    public GameObject UIcontainer;

    private void Start()
    {
        //PV = GetComponent<PhotonView>();
        if (PV == null)
            return;

        PV.RPC("SayMyName", RpcTarget.AllViaServer, PV.Owner.NickName);

        if (!PV.IsMine)
        {
            transform.GetChild(0).gameObject.SetActive(false);
            UIcontainer.gameObject.SetActive(false);
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
        if (PV == null)
        {
            for (int i = 0; i < objectsList.Length; i++)
            {
                objectsList[i].SetActive(false);
            }

            Aiming.SetActive(false);

            if (thisOne != -1)
            {
                objectsList[thisOne].SetActive(true);
                Aiming.SetActive(true);
            }

            ship = thisOne;

            return;
        }

        PV.RPC("SyncActivated", RpcTarget.AllViaServer, thisOne);
    }

    [PunRPC]
    void SyncActivated(int tO, PhotonMessageInfo info)
    {
        for (int i = 0; i < objectsList.Length; i++)
        {
            objectsList[i].SetActive(false);
        }

        Aiming.SetActive(false);

        if (tO != -1)
        {
            objectsList[tO].SetActive(true);
            Aiming.SetActive(true);
        }

        if (objectsList[tO].activeInHierarchy)
        {
            if (objectsList[tO].GetComponent<multi_Fire>() != null)
            {
                Camera.main.GetComponent<TransparentWindow>().ShipCanFire = true;
            }
            else
                Camera.main.GetComponent<TransparentWindow>().ShipCanFire = false;
        }

        ship = tO;
    }

    public override void OnPlayerEnteredRoom(Player newPlayer)
    {
        if (PhotonNetwork.IsMasterClient)
        {
            ActiveThisOne(ship);
        }
    }
}
