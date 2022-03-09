using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Unity.Netcode;

public class GD_Test_UI_MultiEnabler : NetworkBehaviour
{
    public GameObject[] objectsList;
    [SerializeField]
    private NetworkVariable<int> activatedOne = new NetworkVariable<int>();

    public void ActiveThisOne(int thisOne)
    {
        if (IsClient && IsOwner)
            UpdateClientPositionServerRpc(thisOne);
        if (IsServer)
        {
            for (int i = 0; i < objectsList.Length; i++)
            {
                objectsList[i].SetActive(false);
            }
            if (thisOne != -1)
                objectsList[thisOne].SetActive(true);
            UpdateClientPositionServerRpc(thisOne);
        }
    }

    [ServerRpc]
    private void UpdateClientPositionServerRpc (int newOne)
    {
        activatedOne.Value = newOne;
        for (int i = 0; i < objectsList.Length; i++)
        {
            objectsList[i].SetActive(false);
        }
        if (newOne != -1)
            objectsList[newOne].SetActive(true);
    }
}
