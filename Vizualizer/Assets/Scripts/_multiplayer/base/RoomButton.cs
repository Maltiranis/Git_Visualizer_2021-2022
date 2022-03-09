using Photon.Pun;
using Photon.Realtime;
using UnityEngine;
using UnityEngine.UI;

public class RoomButton : MonoBehaviourPunCallbacks
{
    [SerializeField] private Text nameText;
    [SerializeField] private Text sizeText;

    private string roomName;
    private int roomSize;
    private int playerCount;

    public void JoinRoomOnClick()
    {
        PhotonNetwork.JoinRoom(roomName);
    }

    public void SetRoom(string nameInput, int sizeInput, int countInput)
    {
        roomName = nameInput;
        roomSize = sizeInput;
        playerCount = countInput;
        nameText.text = nameInput;
        sizeText.text = countInput + " / " + sizeInput;
    }
}
