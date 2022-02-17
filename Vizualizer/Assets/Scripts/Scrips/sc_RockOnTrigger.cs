using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class sc_RockOnTrigger : MonoBehaviour
{
    public GameObject[] VFX;

    // Start is called before the first frame update
    void Start()
    {
        
    }

    private void OnTriggerEnter(Collider other)
    {
        if (other.name == "MareCollider")
        {
            gameObject.GetComponent<Rigidbody>().drag = 2.0f;
            InstantiateFX();
        }
    }

    private void InstantiateFX ()
    {
        foreach (GameObject vfx in VFX)
        {
            Instantiate(vfx, gameObject.transform.position, Quaternion.identity);
        }
    }
}
