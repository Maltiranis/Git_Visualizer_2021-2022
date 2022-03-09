using Photon.Pun;
using Photon.Realtime;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;
using System.IO;

public class sc_PhotonRoom : MonoBehaviourPunCallbacks, IInRoomCallbacks
{
    public static sc_PhotonRoom room;
    private PhotonView PV;

    public bool isGameLoaded;
    public int currentScene;

    private Player[] photonPlayers;
    public int playersInRoom;
    public int myNumberInRoom;

    public int playersInGame;

    private bool readyToCount;
    private bool readyToStart;
    public float startingTime;
    private float lessThanMaxPlayers;
    private float atMaxPlayers;
    private float timeToStart;

    private void Awake()
    {
        if (sc_PhotonRoom.room == null)
        {
            sc_PhotonRoom.room = this;
        }
        else
        {
            if (sc_PhotonRoom.room != this)
            {
                Destroy(sc_PhotonRoom.room.gameObject);
                sc_PhotonRoom.room = this;
            }
        }
        DontDestroyOnLoad(this.gameObject);
    }

    public override void OnEnable()
    {
        base.OnEnable();
        PhotonNetwork.AddCallbackTarget(this);
        SceneManager.sceneLoaded += OnSceneFinishedLoading;
    }

    public override void OnDisable()
    {
        base.OnDisable();
        PhotonNetwork.RemoveCallbackTarget(this);
        SceneManager.sceneLoaded -= OnSceneFinishedLoading;
    }

    private void Start()
    {
        PV = GetComponent<PhotonView>();
        readyToCount = false;
        readyToStart = false;
        lessThanMaxPlayers = startingTime;
        atMaxPlayers = 6;
        timeToStart = startingTime;
    }

    private void Update()
    {
        if (sc_MultiplayerSettings.multiplayerSettings.delayStart)
        {
            if (playersInRoom == 1)
            {
                RestartTimer();
            }
            if (!isGameLoaded)
            {
                if (readyToStart)
                {
                    atMaxPlayers -= Time.deltaTime;
                    lessThanMaxPlayers = atMaxPlayers;
                    timeToStart = atMaxPlayers;
                }
                else if (readyToCount)
                {
                    lessThanMaxPlayers -= Time.deltaTime;
                    timeToStart = lessThanMaxPlayers;
                }
                if (timeToStart <= 0)
                {
                    StartGame();
                }
            }
        }
    }

    public override void OnJoinedRoom()
    {
        base.OnJoinedRoom();
        photonPlayers = PhotonNetwork.PlayerList;
        playersInRoom = photonPlayers.Length;
        myNumberInRoom = playersInRoom;
        PhotonNetwork.NickName = myNumberInRoom.ToString();
        if (sc_MultiplayerSettings.multiplayerSettings.delayStart)
        {
            if (playersInRoom > 1)
            {
                readyToCount = true;
            }
            if (playersInRoom == sc_MultiplayerSettings.multiplayerSettings.maxPlayers)
            {
                readyToStart = true;
                if (!PhotonNetwork.IsMasterClient)
                {
                    return;
                }
                PhotonNetwork.CurrentRoom.IsOpen = false;
            }
        }
        else
        {
            StartGame();
        }
    }

    public override void OnPlayerEnteredRoom(Player newPlayer)
    {
        base.OnPlayerEnteredRoom(newPlayer);
        photonPlayers = PhotonNetwork.PlayerList;
        playersInRoom++;
        if (sc_MultiplayerSettings.multiplayerSettings.delayStart)
        {
            if (playersInRoom > 1)
            {
                readyToCount = true;
            }
            if (playersInRoom == sc_MultiplayerSettings.multiplayerSettings.maxPlayers)
            {
                readyToStart = true;
                if (!PhotonNetwork.IsMasterClient)
                {
                    return;
                }
                PhotonNetwork.CurrentRoom.IsOpen = false;
            }
        }
    }

    void StartGame()
    {
        isGameLoaded = true;
        if (!PhotonNetwork.IsMasterClient)
        {
            return;
        }
        if (sc_MultiplayerSettings.multiplayerSettings.delayStart)
        {
            PhotonNetwork.CurrentRoom.IsOpen = false;
        }
        PhotonNetwork.LoadLevel(sc_MultiplayerSettings.multiplayerSettings.multiplayerScene);
    }

    void RestartTimer()
    {
        lessThanMaxPlayers = startingTime;
        timeToStart = startingTime;
        atMaxPlayers = 6;
        readyToCount = false;
        readyToStart = false;
    }

    void OnSceneFinishedLoading(Scene scene, LoadSceneMode mode)
    {
        currentScene = scene.buildIndex;
        if (currentScene == sc_MultiplayerSettings.multiplayerSettings.multiplayerScene)
        {
            isGameLoaded = true;

            if (sc_MultiplayerSettings.multiplayerSettings.delayStart)
            {
                PV.RPC("RPC_LoadedGameScene", RpcTarget.MasterClient);
            }
            else
            {
                RPC_CreatePlayer();
            }
        }
    }

    [PunRPC]
    private void RPC_LoadedGameScene()
    {
        playersInGame++;
        if(playersInGame == PhotonNetwork.PlayerList.Length)
        {
            PV.RPC("RPC_CreatePlayer", RpcTarget.All);
        }
    }

    [PunRPC]
    private void RPC_CreatePlayer()
    {
        PhotonNetwork.Instantiate(Path.Combine("PhotonPrefabs", "PhotonNetworkPlayer"), transform.position, Quaternion.identity, 0);
    }
}
