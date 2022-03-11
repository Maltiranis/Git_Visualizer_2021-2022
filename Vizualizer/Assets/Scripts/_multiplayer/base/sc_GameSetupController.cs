using Photon.Pun;
using System.IO;
using UnityEngine;
using System.Collections.Generic;

public class sc_GameSetupController : MonoBehaviour
{
    int s = 0;
    sc_GameSetup scgs;
    [Header("Player list")]
    public Transform ParentObjet;

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
        GameObject pod = PhotonNetwork.Instantiate(Path.Combine("PhotonPrefabs", "PhotonPlayer"), scgs.spawnPoints[s].position, scgs.spawnPoints[s].rotation);
        pod.transform.parent = ParentObjet;
    }
}
