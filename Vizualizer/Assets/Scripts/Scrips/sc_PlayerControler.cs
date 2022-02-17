using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class sc_PlayerControler : MonoBehaviour
{
    [SerializeField] float _movementSpeed = 1.0f;
    [SerializeField] float _rotationSpeed = 1.0f;
    Transform camCenter;
    Transform armPivot;

    void Start()
    {
        camCenter = Camera.main.transform.parent.transform.parent.transform;
        armPivot = Camera.main.transform.parent.transform;
    }

    void Update()
    {
        Move();
        Rotate();
    }

    public void Move()
    {
        Vector3 moving = sc_PlayerMovement.instance.MovementXZ();
        Vector3 moveSpeedVector = 
            moving.x * camCenter.right + 
            moving.z * camCenter.forward;

        transform.Translate(moveSpeedVector * _movementSpeed, Space.World);
    }

    public void Rotate()
    {
        Vector3 Rorating = sc_CameraManager.instance.RRotationXY(_rotationSpeed);

        camCenter.localEulerAngles += new Vector3
        (
            0,
            Rorating.y,
            0
        );
        armPivot.localEulerAngles += new Vector3
        (
            Rorating.x,
            0,
            0
        );
    }
}
