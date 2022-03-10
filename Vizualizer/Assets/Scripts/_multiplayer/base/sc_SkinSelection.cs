using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;
using Photon.Pun;
using Photon.Realtime;

public class sc_SkinSelection : MonoBehaviourPunCallbacks
{
    public int _selected;
    //public GameObject[] _skins;

    private void Awake()
    {
        DontDestroyOnLoad(this.gameObject);
        GameObject[] ogo = GameObject.FindGameObjectsWithTag(this.gameObject.tag);

        foreach (GameObject go in ogo)
        {
            if (go != gameObject)
            {
                Destroy(go);
            }
        }
    }

    public void ButtonToSelected(int s)
    {
        _selected = s;
    }

    /*private void Update()
    {
        if (_skins.Length > 0)
        {
            if (Input.GetAxis("Mouse ScrollWheel") < 0f)
            {
                if (_selected + 1 >= _skins.Length)
                    _selected = 0;
                else
                    _selected++;
            }
            if (Input.GetAxis("Mouse ScrollWheel") > 0f)
            {
                if (_selected - 1 < 0)
                    _selected = _skins.Length - 1;
                else
                    _selected--;
            }
            if (Input.GetAxis("Mouse ScrollWheel") != 0f)
            {
                foreach (GameObject sk in _skins)
                {
                    if (sk != null)
                        sk.SetActive(false);
                }
                if (_skins[_selected] != null)
                    _skins[_selected].SetActive(true);
            }
        }
    }*/

    public void OnDisconnectedFromPhoton()
    {
        Debug.Log("Photon Disconnected");
    }
}
