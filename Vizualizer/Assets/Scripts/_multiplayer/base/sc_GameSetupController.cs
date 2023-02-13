using Photon.Pun;
using System.IO;
using UnityEngine;
using System.Collections.Generic;
using TMPro;
using System.Collections;

public class sc_GameSetupController : MonoBehaviour
{
    //int s = 0;
    sc_GameSetup scgs;
    public GameObject PlayerList;

    private void Start()
    {
        scgs = GetComponent<sc_GameSetup>();
        CreatePlayer();
    }

    private void CreatePlayer()
    {
        /*for (int i = 0; i < PhotonNetwork.PlayerList.Length; i++)
        {
            if (PhotonNetwork.PlayerList[i] == PhotonNetwork.LocalPlayer)
            {
                s = i;
            }
        }
        if (scgs.spawnPoints.Length <= 1)
        {
            s = 0;
        }*/

        //GameObject Player = PhotonNetwork.Instantiate(Path.Combine("PhotonPrefabs", "PhotonPlayer"), scgs.spawnPoints[s].position, scgs.spawnPoints[s].rotation);
        GameObject Player = PhotonNetwork.Instantiate(Path.Combine("PhotonPrefabs", "PhotonPlayer"), scgs.spawnPoints[0].position, scgs.spawnPoints[0].rotation);

        Player.transform.parent = PlayerList.transform;
    }
}
