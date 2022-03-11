using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Photon.Pun;

public class GD_Test_UI_MultiEnabler : MonoBehaviour
{
    [SerializeField]
    public GameObject[] objectsList;
    public PhotonView PV;

    int countIt = 0;

    private void Start()
    {
        PV = GetComponent<PhotonView>();

        if (!PV.IsMine)
        {
            gameObject.SetActive(false);
        }

    }

    private void Update()
    {
        /*if (countIt > 0)
        {
            objectsList[countIt - 1].SetActive(true);
        }*/
    }

    public void ActiveThisOne(int thisOne)
    {
        if (PV.IsMine)
        {
            if (countIt <= 0)
            {
                for (int i = 0; i < objectsList.Length; i++)
                {
                    if (objectsList[i].activeInHierarchy == true)
                    {
                        countIt++;
                    }
                }
            }
            else
            {
                objectsList[countIt - 1].SetActive(true);
            }
            PV.RPC("SyncActivated", RpcTarget.AllBuffered, countIt);
        }

    }

    [PunRPC]
    void SyncActivated(int ci)
    {
        countIt = ci;
        objectsList[countIt - 1].SetActive(true);
    }
}
