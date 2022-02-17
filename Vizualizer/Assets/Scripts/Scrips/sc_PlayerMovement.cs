using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class sc_PlayerMovement : MonoBehaviour
{
    #region Singleton

    public static sc_PlayerMovement instance;

    private void Awake()
    {
        if (instance != null)
        {
            Debug.LogWarning("multiple sc_PlayerMovement instances !!!");
            return;
        }

        instance = this;
    }

    #endregion

    public Vector3 MovementXZ()
    {
        float vertical = Input.GetAxis("Vertical");
        float horizontal = Input.GetAxis("Horizontal");

        return new Vector3(horizontal, 0, vertical);
    }
}
