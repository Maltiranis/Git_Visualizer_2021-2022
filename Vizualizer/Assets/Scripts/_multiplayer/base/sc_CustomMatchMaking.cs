using Photon.Pun;
using Photon.Realtime;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using TMPro;

public class sc_CustomMatchMaking : MonoBehaviourPunCallbacks
{
    [SerializeField] private GameObject _lobbyCoButton;
    [SerializeField] private GameObject _lobbyPanel;
    [SerializeField] private GameObject _mainPanel;
    [SerializeField] private sc_CustomMatchMakingController _CMC;

    public TMP_InputField _playerNameInput;

    private string roomName;
    private int roomSize;

    private List<RoomInfo> roomListings;
    [SerializeField] private Transform roomsContainer;
    [SerializeField] private GameObject roomListingPrefab;

    public override void OnConnectedToMaster()
    {
        PhotonNetwork.AutomaticallySyncScene = true;
        _lobbyCoButton.SetActive(true);
        roomListings = new List<RoomInfo>();

        if (PlayerPrefs.HasKey("NickName"))
        {
            if (PlayerPrefs.GetString("NickName") == "")
            {
                PhotonNetwork.NickName = "Player " + Random.Range(0, 1000);
            }
            else
            {
                PhotonNetwork.NickName = PlayerPrefs.GetString("NickName");
            }
        }
        else
        {
            PhotonNetwork.NickName = "Player " + Random.Range(0, 1000);
        }
        _playerNameInput.text = PhotonNetwork.NickName;
    }

    public void PlayerNameUpdate(string nameInput)
    {
        PhotonNetwork.NickName = nameInput;
        PlayerPrefs.SetString("NickName", nameInput);
    }

    public void JoinLobbyOnClick()
    {
        _mainPanel.SetActive(false);
        _lobbyPanel.SetActive(true);
        PhotonNetwork.JoinLobby();
    }

    public override void OnRoomListUpdate(List<RoomInfo> roomList)
    {
        int tempIndex;
        foreach (RoomInfo room in roomList)
        {
            if (roomListings != null)
            {
                tempIndex = roomListings.FindIndex(ByName(room.Name));
            }
            else
            {
                tempIndex = -1;
            }
            if (tempIndex != -1)
            {
                roomListings.RemoveAt(tempIndex);
                Destroy(roomsContainer.GetChild(tempIndex).gameObject);
            }
            if (room.PlayerCount > 0)
            {
                roomListings.Add(room);
                ListRoom(room);
            }
        }
    }

    static System.Predicate<RoomInfo> ByName(string name)
    {
        return delegate (RoomInfo room)
        {
            return room.Name == name;
        };
    }

    void ListRoom(RoomInfo room)
    {
        if (room.IsOpen && room.IsVisible)
        {
            GameObject tempListing = Instantiate(roomListingPrefab, roomsContainer);
            RoomButton tempButton = tempListing.GetComponent<RoomButton>();
            tempButton.SetRoom(room.Name, room.MaxPlayers, room.PlayerCount);
        }
    }

    public void OnRoomNameChanged(string nameIn)
    {
        roomName = nameIn;
    }

    public void OnRoomSizeChanged(string sizeIn)
    {
        roomSize = int.Parse(sizeIn);
    }

    public void CreateTrainingRoom()
    {
        RoomOptions roomOps = new RoomOptions()
        {
            IsVisible = true,
            IsOpen = true,
            MaxPlayers = (byte)1
        };
        PhotonNetwork.CreateRoom("Training", roomOps);
        _CMC._nextGameIndex = 2;
    }

    public void CreateRoom()
    {
        RoomOptions roomOps = new RoomOptions()
        {
            IsVisible = true,
            IsOpen = true,
            MaxPlayers = (byte)roomSize
        };
        PhotonNetwork.CreateRoom(roomName, roomOps);
        _CMC._nextGameIndex = 1;//CHANGER SI AUTRES MAPS
    }

    public override void OnCreateRoomFailed(short returnCode, string message)
    {
        Debug.Log("creating room failed");
    }

    public void MatchMakingCancel()
    {
        _mainPanel.SetActive(true);
        _lobbyPanel.SetActive(false);
        PhotonNetwork.LeaveLobby();
    }
}
