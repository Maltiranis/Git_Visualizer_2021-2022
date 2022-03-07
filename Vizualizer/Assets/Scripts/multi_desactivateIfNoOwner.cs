using FishNet.Object;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class multi_desactivateIfNoOwner : NetworkBehaviour
{
    void Start()
    {
        if (!base.IsOwner)
            gameObject.SetActive(false);
    }
}
