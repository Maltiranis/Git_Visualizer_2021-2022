using UnityEngine;
using Photon.Pun;

public class FollowMouse : MonoBehaviour
{
    //public GameObject myCam;
    public float offsetZ = 10.0f;
    public float speed = 2.0f;
    public bool instantaneous = false;
    public PhotonView PV;

    void Start()
    {
        //PV = GetComponent<PhotonView>();

        if (PV == null)
            return;

        gameObject.name = PV.Owner.NickName;
    }

    public Vector3 GetFollowMousePos()
    {
        Vector3 temp = Input.mousePosition;
        temp.z = offsetZ;
        return temp;
    }

    void Update()
    {
        if (PV == null)
        {
            followIt();
        }

        if (PV != null)
        {
            if (!PV.IsMine)
            {
                return;
            }
            else
            {
                followIt();
            }
        }
    }

    void followIt()
    {
        if (instantaneous == false)
            this.transform.position = Vector3.Lerp(transform.position, Camera.main.ScreenToWorldPoint(GetFollowMousePos()), speed * Time.deltaTime);
        else
            this.transform.position = Camera.main.ScreenToWorldPoint(GetFollowMousePos());
    }

    // coller ce truc partout : coller le bool du vaisseau actif + le nom du joueur
    public void OnPhotonSerializeView(PhotonStream stream)
    {
        if (PV == null)
            return;

        if (stream.IsWriting)
        {
            stream.SendNext(transform.position);
        }
        else
        {
            transform.position = (Vector3)stream.ReceiveNext();
        }
    }
}
