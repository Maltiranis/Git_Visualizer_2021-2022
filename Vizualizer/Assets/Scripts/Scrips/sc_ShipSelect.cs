using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class sc_ShipSelect : MonoBehaviour
{
    [SerializeField] private GameObject[] _ships;

    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        if (Input.GetKeyDown(KeyCode.Alpha1))
        {
            OnlyActiveOne(0);
        }
        if (Input.GetKeyDown(KeyCode.Alpha2))
        {
            OnlyActiveOne(1);
        }
        if (Input.GetKeyDown(KeyCode.Alpha3))
        {
            OnlyActiveOne(2);
        }
        if (Input.GetKeyDown(KeyCode.Alpha4))
        {
            OnlyActiveOne(3);
        }
    }

    void OnlyActiveOne(int activated)
    {
        foreach (GameObject s in _ships)
        {
            s.SetActive(false);
        }
        _ships[activated].SetActive(true);
    }
}
