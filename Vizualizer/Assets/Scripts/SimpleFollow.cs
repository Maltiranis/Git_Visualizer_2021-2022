using Photon.Pun;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SimpleFollow : MonoBehaviour
{
    public Transform toFollow;
    public float linearSpeed = 2.0f;
    public float angularSpeed = 1.5f;
    //public float stopRange = 1.0f;

    public Vector3 _netPosition;
    public Quaternion _netRotation;

    public Rigidbody rb;

    public PhotonView PV;

    private void Awake()
    {
        PhotonNetwork.SendRate = 30;
        PhotonNetwork.SerializationRate = 10;
    }

    void FixedUpdate()
    {
        _netPosition = toFollow.position;
        _netRotation = toFollow.rotation;

        //float dist = Vector3.Distance(transform.position, toFollow.position);
        //if (stopRange < dist)
        /*if (PV.IsMine)
            return;*/

        rb.position = Vector3.Lerp(rb.position, _netPosition, Time.fixedDeltaTime * linearSpeed);
        //rb.rotation = Quaternion.Lerp(rb.rotation, _netRotation, Time.fixedDeltaTime * angularSpeed);

        /*if (Vector3.Distance(rb.position, _netPosition) > 5.0f)//tp float
        {
            rb.position = _netPosition;
        }*/
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
