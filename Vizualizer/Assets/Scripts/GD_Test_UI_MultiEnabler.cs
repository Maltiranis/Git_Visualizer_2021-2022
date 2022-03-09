using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Unity.Netcode;

public class GD_Test_UI_MultiEnabler : NetworkBehaviour
{
    [SerializeField]
    public GameObject[] objectsList;
    [SerializeField]
    private NetworkVariable<int> ActivatedOne = new NetworkVariable<int>();

    public void ActiveThisOne(int thisOne)
    {
        if (IsOwner)
            ActivateFromOwner(thisOne);

        for (int i = 0; i < objectsList.Length; i++)
        {
            objectsList[i].SetActive(false);
        }
        if (ActivatedOne.Value != -1)
            objectsList[ActivatedOne.Value].SetActive(true);
    }

    void ActivateFromOwner(int tO)
    {
        if (NetworkManager.Singleton.IsServer)
        {
            ActivatedOne.Value = tO;
        }
        else
        {
            UpdateClientPositionServerRpc(tO);
        }
    }

    static int GetGoodNumber(int i)
    {
        return i;
    }

    [ServerRpc]
    private void UpdateClientPositionServerRpc (int newOne, ServerRpcParams rpcParams = default)
    {
        ActivatedOne.Value = GetGoodNumber(newOne);
    }
}
