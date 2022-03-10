using Photon.Pun;
using System.IO;
using UnityEngine;
using System.Collections.Generic;

public class sc_GameSetupController : MonoBehaviour
{
    int s = 0;
    sc_GameSetup scgs;
    public int _selectedSkin = 0;

    private void Start()
    {
        scgs = GetComponent<sc_GameSetup>();
        CreatePlayer();
    }

    private void CreatePlayer()
    {
        for (int i = 0; i < PhotonNetwork.PlayerList.Length; i++)
        {
            if (PhotonNetwork.PlayerList[i] == PhotonNetwork.LocalPlayer)
            {
                s = i;
            }
        }
        _selectedSkin = GameObject.Find("SkinSelector").GetComponent<sc_SkinSelection>()._selected;
        GameObject pod = PhotonNetwork.Instantiate(Path.Combine("PhotonPrefabs", "PhotonPlayer_" + _selectedSkin), scgs.spawnPoints[s].position, scgs.spawnPoints[s].rotation);
    }
}
