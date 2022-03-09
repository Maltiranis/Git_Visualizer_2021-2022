using Photon.Pun;
using Photon.Realtime;
using UnityEngine;
using System.Collections;
using UnityEngine.UI;
using TMPro;

public class sc_CustomMatchMakingController : MonoBehaviourPunCallbacks
{
    //[SerializeField] private int _multiPlayerSceneIndex;
    [SerializeField] private GameObject _lobbyPanel;
    [SerializeField] private GameObject _roomPanel;
    [SerializeField] private GameObject _startButton;
    [SerializeField] public int _nextGameIndex = 0;
    [SerializeField] private Transform _playersContainer;

    [SerializeField] private GameObject _playerListingPrefab;

    [SerializeField] private TMP_Text _roomNameDisplay;

    void ClearPlayerListings()
    {
        for (int i = _playersContainer.childCount - 1; i >= 0; i--)
        {
            Destroy(_playersContainer.GetChild(i).gameObject);
        }
    }

    void ListPlayers()
    {
        foreach (Player player in PhotonNetwork.PlayerList)
        {
            GameObject tempListing = Instantiate(_playerListingPrefab, _playersContainer);
            Text tempText = tempListing.transform.GetChild(0).GetComponent<Text>();
            tempText.text = player.NickName;
        }
    }

    public override void OnJoinedRoom()
    {
        _roomPanel.SetActive(true);
        _lobbyPanel.SetActive(false);
        _roomNameDisplay.text = PhotonNetwork.CurrentRoom.Name;
        if (PhotonNetwork.IsMasterClient)
        {
            _startButton.SetActive(true);
        }
        else
        {
            _startButton.SetActive(false);
        }
        ClearPlayerListings();
        ListPlayers();
    }

    public override void OnPlayerEnteredRoom(Player newPlayer)
    {
        ClearPlayerListings();
        ListPlayers();
    }

    public override void OnPlayerLeftRoom(Player otherPlayer)
    {
        ClearPlayerListings();
        ListPlayers();
        if (PhotonNetwork.IsMasterClient)
        {
            _startButton.SetActive(true);
        }
    }

    public void StartGame()
    {
        if (PhotonNetwork.IsMasterClient)
        {
            PhotonNetwork.CurrentRoom.IsOpen = false;
            PhotonNetwork.LoadLevel(_nextGameIndex);
        }
    }

    IEnumerator rejoinLobby()
    {
        yield return new WaitForSeconds(1);
        PhotonNetwork.JoinLobby();
    }

    public void BackOnClick()
    {
        _lobbyPanel.SetActive(true);
        _roomPanel.SetActive(false);
        PhotonNetwork.LeaveRoom();
        PhotonNetwork.LeaveLobby();
        StartCoroutine(rejoinLobby());
    }

    public void LeaveLobby()
    {
        PhotonNetwork.LeaveLobby();
    }
}
