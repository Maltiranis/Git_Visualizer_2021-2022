using Unity.Netcode;
using UnityEngine;

public class FollowMouse : NetworkBehaviour
{
    //public GameObject myCam;
    public float offsetZ = 10.0f;
    public float speed = 2.0f;
    public bool instantaneous = false;

    public NetworkVariable<Vector3> Position = new NetworkVariable<Vector3>();

    private void Move()
    {
        if (NetworkManager.Singleton.IsServer)
        {
            Vector3 temp = GetFollowMousePos();
            temp.z = offsetZ;
            Position.Value = temp;
        }
        else
        {
            SubmitPositionRequestServerRpc();
        }
    }

    [ServerRpc]
    void SubmitPositionRequestServerRpc(ServerRpcParams rpcParams = default)
    {
        Vector3 temp = GetFollowMousePos();
        temp.z = offsetZ;
        Position.Value = temp;
    }

    static Vector3 GetFollowMousePos ()
    {
        Vector3 temp = Input.mousePosition;

        return temp;
    }

    void Update()
    {
        if (IsOwner)
        {
            Move();
        }

        if (instantaneous == false)
            this.transform.position = Vector3.Lerp(transform.position, Camera.main.ScreenToWorldPoint(Position.Value), speed * Time.deltaTime);
        else
            this.transform.position = Camera.main.ScreenToWorldPoint(Position.Value);
    }
}
