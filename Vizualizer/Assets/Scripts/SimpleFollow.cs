using Photon.Pun;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SimpleFollow : MonoBehaviour
{
    public Transform toFollow;
    public float linearSpeed = 2.0f;
    public float angularSpeed = 1.5f;

    public Vector2 offset;
    public float offsetPower = 5.0f;

    public Vector3 _netPosition;
    public Quaternion _netRotation;

    public Rigidbody rb;

    public PhotonView PV;

    public bool centeredOnTarget = false;

    private void Awake()
    {
        PhotonNetwork.SendRate = 30;
        PhotonNetwork.SerializationRate = 10;
    }

    void FixedUpdate()
    {
        if (offsetPower <= 0)
            offsetPower = 0.1f;

        if (!centeredOnTarget)
        {
            _netPosition = toFollow.position + new Vector3
            (
                offset.x * transform.GetChild(0).transform.localScale.x / offsetPower + .5f,
                offset.y * transform.GetChild(0).transform.localScale.y / offsetPower + .5f,
                toFollow.position.z
            );
        }
        else
        {
            _netPosition = toFollow.position;
        }
            _netRotation = toFollow.rotation;

        rb.position = Vector3.Lerp(rb.position, _netPosition, Time.fixedDeltaTime * linearSpeed);

        //rb.rotation = Quaternion.Lerp(rb.rotation, _netRotation, Time.fixedDeltaTime * angularSpeed);

        /*if (Vector3.Distance(rb.position, _netPosition) > 5.0f)//tp float
        {
            rb.position = _netPosition;
        }*/
    }

    public void SetCenteredOrNot ()
    {
        centeredOnTarget = !centeredOnTarget;
    }

    public void OnPhotonSerializeView(PhotonStream stream, PhotonMessageInfo info)
    {
        if (PV == null)
            return;
        if (stream.IsWriting)
        {
            stream.SendNext(rb.position);
            //stream.SendNext(rb.rotation);
            stream.SendNext(rb.velocity);
        }
        else
        {
            _netPosition = (Vector3)stream.ReceiveNext();
            //_netRotation = (Quaternion)stream.ReceiveNext();
            rb.velocity = (Vector3)stream.ReceiveNext();

            float lag = Mathf.Abs((float)(PhotonNetwork.Time - info.SentServerTime));
            _netPosition += (rb.velocity * lag);
        }
    }
}
