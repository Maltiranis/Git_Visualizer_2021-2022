using Photon.Pun;
using Photon.Realtime;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class sc_PhotonLobby : MonoBehaviourPunCallbacks
{
    public static sc_PhotonLobby lobby;

    public GameObject battleButton;
    public GameObject cancelButton;

    private void Awake()
    {
        lobby = this;
    }

    void Start()
    {
        PhotonNetwork.ConnectUsingSettings();
    }

    public override void OnConnectedToMaster()
    {
        PhotonNetwork.AutomaticallySyncScene = true;
        battleButton.SetActive(true);
    }

    public void OnBattleButtonClicked()
    {
        battleButton.SetActive(false);
        cancelButton.SetActive(true);
        PhotonNetwork.JoinRandomRoom();
    }

    public override void OnJoinRandomFailed(short returnCode, string message)
    {
        CreateRoom();
    }

    void CreateRoom()
    {
        int randomRoomName = Random.Range(0, 10000);
        RoomOptions roomOps = new RoomOptions()
        {
            IsVisible = true,
            IsOpen = true,
            MaxPlayers = (byte)sc_MultiplayerSettings.multiplayerSettings.maxPlayers
        };
        PhotonNetwork.CreateRoom("Room" + randomRoomName, roomOps);
    }

    public override void OnCreateRoomFailed(short returnCode, string message)
    {
        CreateRoom();
    }

    public void OnCancelButtonClicked()
    {
        cancelButton.SetActive(false);
        battleButton.SetActive(true);
        PhotonNetwork.LeaveRoom();
    }
}
