using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class sc_PlayerInfo : MonoBehaviour
{
    public static sc_PlayerInfo PI;

    public int mySelectedCharacter;

    public GameObject[] allCharacters;

    private void OnEnable()
    {
        if (sc_PlayerInfo.PI == null)
        {
            sc_PlayerInfo.PI = this;
        }
        else
        {
            if (sc_PlayerInfo.PI != this)
            {
                Destroy(sc_PlayerInfo.PI.gameObject);
                sc_PlayerInfo.PI = this;
            }
        }
        //DontDestroyOnLoad(this.gameObject);
    }

    void Start()
    {
        if (PlayerPrefs.HasKey("MyCharacter"))
        {
            mySelectedCharacter = PlayerPrefs.GetInt("MyCharacter");
        }
        else
        {
            mySelectedCharacter = 0;
            PlayerPrefs.SetInt("MyCharacter", mySelectedCharacter);
        }
    }

    // Update is called once per frame
    void Update()
    {
        
    }
}
