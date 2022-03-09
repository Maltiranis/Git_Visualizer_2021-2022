using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class sc_GameSetup : MonoBehaviour
{
    public static sc_GameSetup GS;

    public Transform[] spawnPoints;
    public Transform[] AIspawnPoints;

    private void OnEnable()
    {
        if (sc_GameSetup.GS == null)
        {
            sc_GameSetup.GS = this;
        }
    }
}
