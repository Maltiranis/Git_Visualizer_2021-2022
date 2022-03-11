using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SpawnMeAShip : MonoBehaviour
{
    public GameObject PlayerList;
    public GameObject ToInstantiate;

    void Update()
    {
        if (transform.childCount < PlayerList.transform.childCount)
        {
            GameObject ship = Instantiate(ToInstantiate, transform);
        }

        if (transform.childCount > PlayerList.transform.childCount)
        {
            Destroy(transform.GetChild(transform.childCount - 1)); // Attention au bug
        }
    }
}
