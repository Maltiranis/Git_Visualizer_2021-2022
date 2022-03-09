using Photon.Pun;
using System.IO;
using UnityEngine;
using System.Collections.Generic;

public class sc_GameSetupController : MonoBehaviour
{
    public bool _haveScoreboard = true;

    int s = 0;
    sc_GameSetup scgs;
    public int _selectedSkin = 0;
    List<GameObject> IAs = new List<GameObject>();

    private void Start()
    {
        scgs = GetComponent<sc_GameSetup>();
        CreatePlayer();

        if (PhotonNetwork.IsMasterClient)
        {
            CreateAI();
        }
    }

    private void CreatePlayer()
    {
        for (int i = 0; i < PhotonNetwork.PlayerList.Length; i++)
        {
            if (PhotonNetwork.PlayerList[i] == PhotonNetwork.LocalPlayer)
            {
                s = i;
                //_selectedSkin = s;
            }
        }
        _selectedSkin = GameObject.Find("SkinSelector").GetComponent<sc_SkinSelection>()._selected;
        GameObject pod = PhotonNetwork.Instantiate(Path.Combine("PhotonPrefabs", "PhotonPlayer_" + _selectedSkin), scgs.spawnPoints[s].position, scgs.spawnPoints[s].rotation);
        if (_haveScoreboard == false)
        {
            pod.GetComponent<sc_LapAchieved>()._CanvasUI.SetActive(false);
            pod.GetComponent<sc_LapAchieved>().enabled = false;
        }
    }

    private void CreateAI()
    {
        for (int i = 0; i < scgs.AIspawnPoints.Length; i++)
        {
            GameObject AIpod = PhotonNetwork.Instantiate(Path.Combine("PhotonPrefabs", "PhotonIA"), scgs.AIspawnPoints[s].position, scgs.AIspawnPoints[s].rotation);
            AIpod.name = "A.I. " + i;
        }
    }
}
