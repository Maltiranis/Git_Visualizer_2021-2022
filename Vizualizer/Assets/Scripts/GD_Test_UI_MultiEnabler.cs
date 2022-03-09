using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GD_Test_UI_MultiEnabler : MonoBehaviour
{/*
    [SerializeField]
    public GameObject[] objectsList;
    [SerializeField]
    private NetworkVariable<int> ActivatedOne = new NetworkVariable<int>();

    int countIt = 0;

    private void Start()
    {
        if (!IsOwner)
            gameObject.SetActive(false);
    }

    private void Update()
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
            objectsList[ActivatedOne.Value].SetActive(true);
        }
    }

    public void ActiveThisOne(int thisOne)
    {
        if (IsServer)
        {
            UpdateActivateOnServer();
        }
        if (IsClient && IsOwner)
        {
            UpdateActivateOnClient(thisOne);
        }
    }

    public void UpdateActivateOnServer()
    {
        for (int i = 0; i < objectsList.Length; i++)
        {
            objectsList[i].SetActive(false);
        }
        if (ActivatedOne.Value != -1)
            objectsList[ActivatedOne.Value].SetActive(true);
    }

    public void UpdateActivateOnClient(int thisOne)
    {
        for (int i = 0; i < objectsList.Length; i++)
        {
            objectsList[i].SetActive(false);
        }
        if (thisOne != -1)
            objectsList[thisOne].SetActive(true);

        UpdateClientActivatedServerRpc(thisOne);
    }

    [ServerRpc]
    void UpdateClientActivatedServerRpc(int thisOne)
    {
        ActivatedOne.Value = thisOne;
    }*/
}
