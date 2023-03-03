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

    public int ship = -1;

    public GameObject UIcontainer;
    public GameObject InputFieldPrefab;
    Transform TchatTransform;


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
        {
            PV.RPC("SyncShips", RpcTarget.AllViaServer);
        }
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

    public void CheckForTchatTransform ()
    {
        if (GameObject.FindWithTag("TCHAT") != null)
        {
            if (TchatTransform == null)
            {
                TchatTransform = GameObject.FindWithTag("TCHAT").transform;

                PV.RPC("CallDialogInput", RpcTarget.AllViaServer);
            }
        }
    }

    [PunRPC]
    void CallDialogInput(PhotonMessageInfo info)
    {
        if (GameObject.FindWithTag("TCHAT") != null)
        {
            TchatTransform = GameObject.FindWithTag("TCHAT").transform;
            GameObject newInputField = (GameObject)Instantiate
            (
                InputFieldPrefab,
                TchatTransform.position,
                TchatTransform.rotation
            );

            newInputField.transform.parent = TchatTransform;
            newInputField.transform.localScale = Vector3.one;

            RectTransform rt = newInputField.GetComponent<RectTransform>();
            rt.anchoredPosition = new Vector2(0, 0);
            rt.sizeDelta = new Vector2(-257.78f, 17.111f);
            rt.localScale = new Vector3(1.7448f, 1.7448f, 1.7448f);

            newInputField.GetComponent<PhotonTchat>().PV = PV;
        }
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

            if (objectsList[tO].activeInHierarchy)
            {
                if (objectsList[tO].GetComponent<multi_Fire>() != null)
                {
                    Camera.main.GetComponent<TransparentWindow>().ShipCanFire = true;
                }
                else
                    Camera.main.GetComponent<TransparentWindow>().ShipCanFire = false;
            }
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
