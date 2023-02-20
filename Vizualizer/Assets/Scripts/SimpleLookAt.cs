using Photon.Pun;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SimpleLookAt : MonoBehaviour
{
    public Transform looked;
    public float lookatSpeed = 2.0f;
    public float forwardPower = 0.1f; //défault 0.05f

    GameObject shipList;
    GameObject playerList;

    public GameObject modelsContainer;

    private void Awake()
    {
        shipList = GameObject.Find("ShipList");
        playerList = GameObject.Find("PlayerList");
    }

    private void Start()
    {
        
    }

    void DefineProfile(scriptable_VehicleProfil getSVP)
    {
        SimpleFollow sF = GetComponent<SimpleFollow>();

        sF.linearSpeed = getSVP.translateSpeed;
        sF.angularSpeed = getSVP.rotateSpeed;
        lookatSpeed = getSVP.lookSpeed;
        forwardPower = getSVP.forwardPow;

        if (getSVP.isSidescroller == true)
        {
            sF.angularSpeed = 0;
            lookatSpeed = 0;
            Quaternion zeroQuat = new Quaternion(0, 0, 0, 0);
            transform.rotation = zeroQuat;
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
                DefineProfile(modelsContainer.transform.GetChild(i).gameObject.GetComponent<ScriptableObject_Container>().myScriptable);
            }
        }

        Vector3 myPos = transform.position;
        Vector3 curPos = looked.position;

        Vector3 relativePos = curPos - myPos;
        Vector3 addVectors = (relativePos - transform.forward) + Vector3.forward * forwardPower;

        Quaternion toRotation = Quaternion.LookRotation(-relativePos, -addVectors);

        transform.rotation = Quaternion.Lerp(transform.rotation, toRotation, Time.deltaTime * lookatSpeed);
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
