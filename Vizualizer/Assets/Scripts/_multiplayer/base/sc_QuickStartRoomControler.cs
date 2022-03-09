using Photon.Pun;
using UnityEngine;

public class sc_QuickStartRoomControler : MonoBehaviourPunCallbacks
{
    [SerializeField] private int _multiplayerSceneIndex;

    public override void OnEnable()
    {
        PhotonNetwork.AddCallbackTarget(this);
    }

    public override void OnDisable()
    {
        PhotonNetwork.RemoveCallbackTarget(this);
    }

    public override void OnJoinedRoom()
    {
        StartGame();
    }

    private void StartGame()
    {
        if (PhotonNetwork.IsMasterClient)
        {
            PhotonNetwork.LoadLevel(_multiplayerSceneIndex);
        }
    }
}
