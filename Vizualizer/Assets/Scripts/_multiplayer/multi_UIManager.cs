using TMPro;
using Unity.Netcode;
using UnityEngine;
using UnityEngine.UI;

public class multi_UIManager : MonoBehaviour
{
    [SerializeField]
    private Button startServerButton;
    [SerializeField]
    private Button startHostButton;
    [SerializeField]
    private Button startClientButton;
    [SerializeField]
    private TextMeshProUGUI playersInGameText;

    private void Awake()
    {
        Cursor.visible = true;
    }

    void Update()
    {
        playersInGameText.text = $"Players in game : {multi_PlayerManager.instance.PlayersInGame}";
    }

    void Start()
    {
        startServerButton.onClick.AddListener(() =>
        {
            if (NetworkManager.Singleton.StartServer())
            {
                Debug.Log("Server started...");
            }
            else
            {
                Debug.Log("Server could not be started...");
            }
        });
        startHostButton.onClick.AddListener(() =>
        {
            if (NetworkManager.Singleton.StartHost())
            {
                Debug.Log("Host started...");
            }
            else
            {
                Debug.Log("Host could not be started...");
            }
        });
        startClientButton.onClick.AddListener(() =>
        {
            if (NetworkManager.Singleton.StartClient())
            {
                Debug.Log("Client started...");
            }
            else
            {
                Debug.Log("Client could not be started...");
            }
        });
    }
}
