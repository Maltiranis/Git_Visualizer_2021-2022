using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class sc_MenuController : MonoBehaviour
{
    public void OnClickCharacterPick(int whichCharacter)
    {
        if (sc_PlayerInfo.PI != null)
        {
            sc_PlayerInfo.PI.mySelectedCharacter = whichCharacter;
            PlayerPrefs.SetInt("MyCharacter", whichCharacter);
        }
    }
}
