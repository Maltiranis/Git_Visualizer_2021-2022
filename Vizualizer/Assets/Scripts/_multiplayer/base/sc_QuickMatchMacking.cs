using Photon.Pun;
using Photon.Realtime;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class sc_QuickMatchMacking : MonoBehaviourPunCallbacks
{
    [SerializeField] private GameObject _quickStartBtn;
    [SerializeField] private GameObject _quickCancelBtn;
    [SerializeField] private int _roomSize = 10;

    public override void OnConnectedToMaster()
    {
        PhotonNetwork.AutomaticallySyncScene = true;
        _quickStartBtn.SetActive(true);
    }

    public void QuickStart()
    {
        _quickStartBtn.SetActive(false);
        _quickCancelBtn.SetActive(true);

        PhotonNetwork.JoinRandomRoom();
    }

    public override void OnJoinRandomFailed(short returnCode, string message)
    {
        CreateRoom();
    }

    void CreateRoom()
    {
        int randomRoomNumber = Random.Range(0, 10000);
        RoomOptions roomOps = new RoomOptions()
        {
            IsVisible = true,
            IsOpen = true,
            MaxPlayers = (byte)_roomSize
        };
        PhotonNetwork.CreateRoom("Room" + randomRoomNumber, roomOps);
    }

    public override void OnCreateRoomFailed(short returnCode, string message)
    {
        CreateRoom();
    }

    public void QuickCancel()
    {
        _quickCancelBtn.SetActive(false);
        _quickStartBtn.SetActive(true);
        PhotonNetwork.LeaveRoom();
    }
}
