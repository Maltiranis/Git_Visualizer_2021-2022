using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TpGoa : MonoBehaviour
{
    public GameObject tp1;
    public GameObject tp2;
	Vector3 offset1;
	Vector3 offset2;
	Vector3 pPos;
	GameObject player;
	public float detectMargin = 0.2f;
	public bool engaged = false;
	
	public Animation anim1;
	public Animation anim2;
	public AudioSource audio1;
	public AudioSource audio2;
	
	public float tpPhysique = 2.0f;
	public float reloadTimer = 5.0f;

    void Start()
    {
        offset1 = tp1.transform.position;
        offset2 = tp2.transform.position;
    }

	public void ReloadTp ()
	{
		engaged = false;
	}

	public void leTp1 ()
	{
		player = GameObject.FindWithTag("Player");
        player.transform.position = offset2;
		Invoke("ReloadTp", reloadTimer);
	}

	public void leTp2 ()
	{
		player = GameObject.FindWithTag("Player");
        player.transform.position = offset1;
		Invoke("ReloadTp", reloadTimer);
	}

    void Update()
    {
		player = GameObject.FindWithTag("Player");
        pPos = player.transform.position;
		
		// comparaison des positions : player/tp1 et player/tp2 avec un offset
		float dist1 = Vector3.Distance(pPos, offset1);
		float dist2 = Vector3.Distance(pPos, offset2);
		
		if (engaged == false)
		{
			if (dist1 <= detectMargin)
			{
				anim1.Play("GoaTpRings");
				anim2.Play("GoaTpRings");
				audio1.Play(0);
				Invoke("leTp1", tpPhysique);
				engaged = true;
				return;
			}
			if (dist2 <= detectMargin)
			{
				anim1.Play("GoaTpRings");
				anim2.Play("GoaTpRings");
				audio2.Play(0);
				Invoke("leTp2", tpPhysique);
				engaged = true;
				return;
			}
		}
    }
}
