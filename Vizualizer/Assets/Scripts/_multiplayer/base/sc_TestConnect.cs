using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Photon.Pun;

public class sc_TestConnect : MonoBehaviourPunCallbacks
{
    [SerializeField] private bool _coToMaster = false;
    void Start()
    {
        //Screen.fullScreen = false;

        if (PhotonNetwork.InRoom)
        {
            PhotonNetwork.LeaveRoom();
        }
        PhotonNetwork.ConnectUsingSettings();
    }

    public override void OnConnectedToMaster()
    {
        _coToMaster = true;
    }

    public void ForceConnect()
    {
        if (!PhotonNetwork.IsConnected)
        {
            PhotonNetwork.ConnectUsingSettings();
        }
    }/*

    private void Update()
    {
        if (Input.GetKeyDown("f11"))
        {
            Screen.fullScreen = !Screen.fullScreen;
        }
    }*/
}
