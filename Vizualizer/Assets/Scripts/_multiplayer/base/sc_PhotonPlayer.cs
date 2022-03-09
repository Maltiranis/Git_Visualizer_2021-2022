using Photon.Pun;
using System.IO;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class sc_PhotonPlayer : MonoBehaviour
{
    private PhotonView PV;

    public GameObject _myAvatar;

    void Start()
    {
        PV = GetComponent<PhotonView>();
        int spawnPicker = Random.Range(0, sc_GameSetup.GS.spawnPoints.Length);
        if (PV.IsMine)
        {
            _myAvatar = PhotonNetwork.Instantiate(Path.Combine("PhotonPrefabs", "PlayerAvatar"), 
                sc_GameSetup.GS.spawnPoints[spawnPicker].position, sc_GameSetup.GS.spawnPoints[spawnPicker].rotation, 0);
        }
    }
}
