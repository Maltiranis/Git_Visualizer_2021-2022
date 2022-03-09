using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class sc_MultiplayerSettings : MonoBehaviour
{
    public static sc_MultiplayerSettings multiplayerSettings;
    public bool delayStart;
    public int maxPlayers;

    public int menuScene;
    public int multiplayerScene;

    private void Awake()
    {
        if (sc_MultiplayerSettings.multiplayerSettings == null)
        {
            sc_MultiplayerSettings.multiplayerSettings = this;
        }
        else
        {
            if (sc_MultiplayerSettings.multiplayerSettings != this)
            {
                Destroy(this.gameObject);
            }
        }
        DontDestroyOnLoad(this.gameObject);
    }
}
