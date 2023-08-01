using System.Collections;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;
using UnityEngine.UI;

public class Use_DHD : MonoBehaviour
{
    public Stargate_DoorParameters SDP;
    [Space(10)]
    public GameObject[] buttonsDHD;
    public GameObject buttonActivation;
    public int[] buttonsDHDint;
    [Space(10)]
    public Material[] _idle;
    public Material[] _activated;

    public MeshRenderer[] rend;

    [Space(10)]
    [Header("Sounds")]
    public AudioClip[] audioClip;
    GameObject soundObject;
    public GameObject soundPrefab;

    Ray ray;
    RaycastHit hit;

    public void Start()
    {
        rend = new MeshRenderer[buttonsDHD.Length];

        ButtonsForceIdle();

        buttonActivation.transform.GetChild(0).gameObject.SetActive(false);
    }

    public void ButtonsForceIdle ()
    {
        for (int i = 0; i < buttonsDHD.Length; i++)
        {
            rend[i] = buttonsDHD[i].GetComponent<MeshRenderer>();
            rend[i].enabled = true;

            rend[i].materials = _idle;
        }
    }

    private void Update()
    {
        ray = Camera.main.ScreenPointToRay(Input.mousePosition);

        if (SDP.lockChevron == true || SDP.unlockChevron == true)
            return;

        if (Input.GetMouseButtonDown(0))
        {
            for (int i = 0; i < buttonsDHD.Length; i++)
            {
                if (Physics.Raycast(ray, out hit, 500))
                {
                    if (SDP.sequence != SDP.chevrons.Length)
                    {
                        if (hit.transform.name == buttonsDHD[i].name)
                        {
                            SDP.haveDHD = true;

                            MeshRenderer bdhdRend = buttonsDHD[i].GetComponent<MeshRenderer>();

                            SDP.ForceChevronStep();
                            bdhdRend.materials = _activated;

                            PlaySound(Random.Range(0, 6));
                        }
                    }

                    if (hit.transform.name == buttonActivation.name)
                    {
                        if (SDP.sequence == SDP.chevrons.Length && SDP.canClose == false)
                        {
                            SDP.ActivateVortex();
                            buttonActivation.transform.GetChild(0).gameObject.SetActive(true);

                            PlaySound(7);
                        }

                        if (SDP.sequence != SDP.chevrons.Length)
                        {
                            SDP.DesactivateDoor();
                            buttonActivation.transform.GetChild(0).gameObject.SetActive(false);
                            ButtonsForceIdle();

                            PlaySound(8);
                        }

                        if (SDP.canClose == true)
                        {
                            SDP.CloseDoor();
                            buttonActivation.transform.GetChild(0).gameObject.SetActive(false);
                            ButtonsForceIdle();
                        }
                    }
                }
            }
        }
    }

    public void PlaySound(int n)
    {
        if (soundObject != null)
        {
            return;
        }
        soundObject = Instantiate(soundPrefab, transform);
        AudioSource loopsource = soundObject.GetComponent<AudioSource>();
        loopsource.clip = audioClip[n];
        loopsource.Play();

        Destroy(soundObject, loopsource.clip.length);
    }

    public void StopSound()
    {
        if (soundObject == null) { return; }
        Destroy(soundObject, 0.0f);
        soundObject = null;
    }
}
