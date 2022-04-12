using Photon.Pun;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SimpleLookAt : MonoBehaviour
{
    public Transform looked;
    public float lookatSpeed = 2.0f;

    GameObject shipList;
    GameObject playerList;

    public GameObject modelsContainer;
    public string getTag;
    public string[] tagsList = {"car", "spaceship", "plane", "boat"};
    bool noRotXY = false;

    private void Awake()
    {
        shipList = GameObject.Find("ShipList");
        playerList = GameObject.Find("PlayerList");

        //On est dans la ShipList avec cet objet
    }

    private void Start()
    {
        //StartCoroutine(rotationPilot());
    }

    void DefineProfile(int i)
    {
        SimpleFollow sF = GetComponent<SimpleFollow>();

        switch (i)
        {
            case 0:
                sF.speed = 2.0f;
                lookatSpeed = 30.0f;
                noRotXY = true;
                break;
            case 1:
                sF.speed = 7.0f;
                lookatSpeed = 10.0f;
                noRotXY = false;
                break;
            case 2:
                sF.speed = 1.0f;
                lookatSpeed = 2.0f;
                noRotXY = false;
                break;
            case 3:
                sF.speed = 2.0f;
                lookatSpeed = 1.5f;
                noRotXY = false;
                break;

            default:
                break;
        }
    }

    void Update()
    {
        if (looked == null)
        {
            return;
        }

        for (int i = 0; i < modelsContainer.transform.childCount; i++)
        {
            if (modelsContainer.transform.GetChild(i).gameObject.activeSelf == true)
            {
                getTag = modelsContainer.transform.GetChild(i).gameObject.tag;

                for (int j = 0; j < tagsList.Length; j++)
                {
                    if (getTag == tagsList[j])
                    {
                        DefineProfile(j);
                    }
                }
            }
        }

        Vector3 myPos = transform.position;
        Vector3 curPos = looked.position;

        Vector3 relativePos = curPos - myPos;
        Vector3 addVectors = (relativePos - transform.forward) + Vector3.forward/4;

        Quaternion toRotation = Quaternion.LookRotation(-relativePos, -addVectors);

        transform.rotation = Quaternion.Lerp(transform.rotation, toRotation, Time.deltaTime * lookatSpeed);
        if (noRotXY)
        {
            //transform.rotation = new Quaternion(-90, transform.rotation.y, transform.rotation.z, transform.rotation.w);
        }
    }

    IEnumerator rotationPilot()
    {
        float rotNow = Random.Range(.5f, 2.0f);

        yield return new WaitForSeconds(rotNow);
        StartCoroutine(rotationPilot());
    }

    public void OnPhotonSerializeView(PhotonStream stream)
    {
        if (stream.IsWriting)
        {
            stream.SendNext(looked);
        }
        else
        {
            looked = (Transform)stream.ReceiveNext();
        }
    }
}
