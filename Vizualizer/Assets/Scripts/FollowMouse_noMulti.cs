using UnityEngine;
using Photon.Pun;

public class FollowMouse_noMulti : MonoBehaviour
{
    public float offsetZ = 10.0f;
    public float speed = 2.0f;
    public bool instantaneous = false;

    public Vector3 GetFollowMousePos ()
    {
        Vector3 temp = Input.mousePosition;
        temp.z = offsetZ;
        return temp;
    }

    void Update()
    {
        if (instantaneous == false)
            this.transform.position = Vector3.Lerp(transform.position, Camera.main.ScreenToWorldPoint(GetFollowMousePos()), speed * Time.deltaTime);
        else
            this.transform.position = Camera.main.ScreenToWorldPoint(GetFollowMousePos());
    }
}
