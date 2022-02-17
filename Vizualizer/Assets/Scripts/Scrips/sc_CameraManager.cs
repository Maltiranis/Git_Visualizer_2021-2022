using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class sc_CameraManager : MonoBehaviour
{
    #region Singleton

    public static sc_CameraManager instance;

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

    public Vector3 RRotationXY(float _rotationSpeed)
    {
        float vertical = Input.GetAxis("Mouse Y") * _rotationSpeed;
        float horizontal = Input.GetAxis("Mouse X") * _rotationSpeed;

        return new Vector3(-vertical, horizontal, 0);
    }
}
