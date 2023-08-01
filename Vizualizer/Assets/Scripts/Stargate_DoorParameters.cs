using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using static UnityEngine.GraphicsBuffer;
using TMPro;

public class Stargate_DoorParameters : MonoBehaviour
{
    [Header("Keyboard & rotation")]
    public bool haveDHD = false;
    public float degrees;
    public GameObject disc;

    public GameObject[] Keys;
    public Color ActivatedKey;
    public Color DesactivatedKey;

    public float dir = 1.0f;
    public float speed = 20.0f;

    public bool isStatic = true;
    public float nextDegToReach = 0.0f;
    [Space(10)]
    [Header("Sequence")]
    public int sequence = 0;
    public int sequenceMaxi = 7;
    public bool seqValidated = false;
    [HideInInspector] public bool canClose = false;
    [Space(10)]
    [Header("Modules")]
    public bool activGen = false;
    public bool activEPPZ = false;
    [Space(10)]
    [Header("Chevrons & Lights")]
    public GameObject[] _chevrons;
    public GameObject[] _lights;
    public bool lockChevron = false;
    public bool unlockChevron = false;
    bool ChevronLockingSequenceSucces = true;
    [HideInInspector]public GameObject[] chevrons;
    GameObject[] lights;
    [Space(10)]
    [Header("Animations")]
    public AnimationClip[] anim;
    public bool irisOpen = true;
    public bool irisMoving = false;
    [Space(10)]
    [Header("Sounds")]
    public AudioClip[] audioClip;
    GameObject soundObject;
    GameObject parallelSoundObject;
    public GameObject soundPrefab;

    //Sequençage
    GameObject[] chevronsS7;
    GameObject[] chevronsS8;
    GameObject[] chevronsS9;
    GameObject[] lightsS7;
    GameObject[] lightsS8;
    GameObject[] lightsS9;
     
    void Start()
    {
        disc.transform.localRotation = new Quaternion(0, 0, 0, 0);

        ModulesSequencing();
    }

    public void OnKeyPressed(GameObject go)
    {
        if (seqValidated == true)
            return;
        if (ChevronLockingSequenceSucces == false)
            return;

        haveDHD = false;

        Image imageComp = go.GetComponent<Image>();
        Material mat = Instantiate(imageComp.material);
        mat.SetColor("_Color0", ActivatedKey * 10);
        imageComp.material = mat;
    }

    public void OnResetKeyboard()
    {
        foreach (GameObject k in Keys)
        {
            Image imageComp = k.GetComponent<Image>();
            Material mat = Instantiate(imageComp.material);
            mat.SetColor("_Color0", DesactivatedKey * 2);
            imageComp.material = mat;
        }
    }

    void ModulesSequencing()
    {
        chevronsS7 = new GameObject[_chevrons.Length - 2];
        lightsS7 = new GameObject[_lights.Length - 2];

        chevronsS8 = new GameObject[_chevrons.Length - 1];
        lightsS8 = new GameObject[_lights.Length - 1];

        chevronsS9 = new GameObject[_chevrons.Length];
        lightsS9 = new GameObject[_lights.Length];

        chevrons = new GameObject[chevronsS7.Length];
        chevrons = chevronsS7;

        lights = new GameObject[lightsS7.Length];
        lights = lightsS7;


        for (int i = 0; i < chevronsS7.Length; i++)
        {
            chevronsS7[i] = _chevrons[i];
        }

        for (int i = 0; i < lightsS7.Length; i++)
        {
            lightsS7[i] = _lights[i];
        }

        chevronsS8[0] = _chevrons[0];
        chevronsS8[1] = _chevrons[1];
        chevronsS8[2] = _chevrons[2];
        chevronsS8[3] = _chevrons[3];
        chevronsS8[4] = _chevrons[4];
        chevronsS8[5] = _chevrons[5];
        chevronsS8[6] = _chevrons[7];
        chevronsS8[7] = _chevrons[6];

        chevronsS9[0] = _chevrons[0];
        chevronsS9[1] = _chevrons[1];
        chevronsS9[2] = _chevrons[2];
        chevronsS9[3] = _chevrons[3];
        chevronsS9[4] = _chevrons[4];
        chevronsS9[5] = _chevrons[5];
        chevronsS9[6] = _chevrons[7];
        chevronsS9[7] = _chevrons[8];
        chevronsS9[8] = _chevrons[6];

        lightsS8[0] = _lights[0];
        lightsS8[1] = _lights[1];
        lightsS8[2] = _lights[2];
        lightsS8[3] = _lights[3];
        lightsS8[4] = _lights[4];
        lightsS8[5] = _lights[5];
        lightsS8[6] = _lights[7];
        lightsS8[7] = _lights[6];

        lightsS9[0] = _lights[0];
        lightsS9[1] = _lights[1];
        lightsS9[2] = _lights[2];
        lightsS9[3] = _lights[3];
        lightsS9[4] = _lights[4];
        lightsS9[5] = _lights[5];
        lightsS9[6] = _lights[7];
        lightsS9[7] = _lights[8];
        lightsS9[8] = _lights[6];
    }

    void Update()
    {
        if (haveDHD == true)
        {
            ChevronLockingProcess();
        }
        else
        {
            if (isStatic == false)
            {
                RotateDoor();
            }

            ChevronLockingProcess();
        }
    }

    public void ChevronLockingProcess()
    {
        if (lockChevron == true)
        {
            if (chevrons[sequence].transform.GetChild(1).localPosition.y > 3.95f)
            {
                chevrons[sequence].transform.GetChild(1).localPosition = new Vector3(0, Mathf.Lerp(chevrons[sequence].transform.GetChild(1).localPosition.y, 3.95f, Time.deltaTime * 4), 0);

                if (haveDHD == false)
                    PlaySound(Random.Range(0,2), false);
                else
                {
                    PlaySound(Random.Range(9, 15), false);
                }
            }
            if (chevrons[sequence].transform.GetChild(1).localPosition.y <= 3.96f)
            {
                ActivateLight();
                unlockChevron = true;
                lockChevron = false;
            }
        }

        if (unlockChevron == true)
        {
            chevrons[sequence].transform.GetChild(1).localPosition = new Vector3(0, Mathf.Lerp(chevrons[sequence].transform.GetChild(1).localPosition.y, 4.1f, Time.deltaTime * 4), 0);

            if (chevrons[sequence].transform.GetChild(1).localPosition.y >= 4.09f)
            {
                ActivateChevron();
                unlockChevron = false;
            }
        }
    }

    public void PlaySound(int n, bool looped) //instancie un gameobject avec une audiosource dessus, pas un préfab
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

    public void PlayParallelSound(int n, bool looped) //instancie un gameobject avec une audiosource dessus, pas un préfab
    {
        if (parallelSoundObject != null)
        {
            return;
        }
        parallelSoundObject = Instantiate(soundPrefab, transform);
        AudioSource loopsource = parallelSoundObject.GetComponent<AudioSource>();
        loopsource.clip = audioClip[n];
        loopsource.Play();

        Destroy(parallelSoundObject, loopsource.clip.length);
    }

    public void StopSound()
    {
        if (soundObject == null) { return; }
        Destroy(soundObject, 0.0f);
        soundObject = null;
    }

    public void OnGlyphClic(int glyphnum)
    {
        if (unlockChevron == true || lockChevron == true)
            return;
        if (seqValidated == true)
            return;
        if (ChevronLockingSequenceSucces == false)
            return;

        nextDegToReach = -degrees * (glyphnum - 1);

        if (nextDegToReach < disc.transform.localRotation.x)
        {
            dir = -1;
        }
        else
        {
            dir = 1;
        }

        isStatic = false;

        canClose = true;
    }

    public void RotateDoor ()
    {
        ChevronLockingSequenceSucces = false;

        PlaySound(3, true);

        //disc.transform.localRotation = Quaternion.RotateTowards(disc.transform.localRotation, Quaternion.Euler(nextDegToReach * 360 + 360, 0, 0), -Time.deltaTime * speed);
        disc.transform.Rotate(Vector3.right * dir * speed * Time.deltaTime, Space.Self);

        if (disc.transform.localRotation == Quaternion.Euler(nextDegToReach * 360, 0, 0))
        {
            isStatic = true;
            lockChevron = true;

            StopSound();
        }
    }

    public void ForceChevronStep ()
    {
        ChevronLockingSequenceSucces = false;

        lockChevron = true;

        StopSound();
    }

    public void ActivateChevron()
    {
        if (sequence != chevrons.Length)
        {
            sequence++;
        }

        ChevronLockingSequenceSucces = true;

        if (!haveDHD)
        {
            if (sequence == chevrons.Length)
            {
                ActivateVortex();
            }
        }
    }

    public void ActivateLight()
    {
        _lights[sequence].gameObject.SetActive(true);
    }

    public void OnForceActivation ()
    {
        foreach (var l in _lights)
        {
            l.gameObject.SetActive(true);
        }
        ActivateVortex();
    }

    public void ActivateVortex()
    {
        StopSound();

        PlaySound(4, false);

        if (irisOpen == true)
            transform.GetChild(0).GetChild(0).gameObject.SetActive(false);
        else
            transform.GetChild(0).GetChild(0).gameObject.SetActive(true);

        transform.GetChild(0).GetComponent<Animation>().clip = anim[0];
        transform.GetChild(0).GetComponent<Animation>().Play();

        seqValidated = true;
        canClose = false;

        StartCoroutine(Chrono(anim[0].length));
    }

    IEnumerator Chrono(float len)
    {
        yield return new WaitForSeconds(len);

        canClose = true;
    }

    public void CloseDoor()
    {
        if (canClose == false)
            return;

        StopSound();

        PlaySound(5, false);

        transform.GetChild(0).GetComponent<Animation>().clip = anim[1];
        transform.GetChild(0).GetComponent<Animation>().Play();

        StartCoroutine(Chrono2(anim[0].length));
    }

    IEnumerator Chrono2(float len)
    {
        yield return new WaitForSeconds(len);

        DesactivateDoor();
    }

    public void DesactivateDoor()
    {
        foreach (GameObject go in _lights)
        {
            go.SetActive(false);
        }
        seqValidated = false;
        canClose = false;
        OnResetKeyboard();
        sequence = 0;
    }

    public void ActivateIris()
    {
        if (irisMoving == false)
        {
            if (irisOpen == true)
            {
                transform.GetComponent<Animation>().clip = anim[2];
                transform.GetComponent<Animation>().Play();

                PlayParallelSound(7, false);

                StartCoroutine(IrisEnum(anim[2].length));
            }
            if (irisOpen == false)
            {
                transform.GetComponent<Animation>().clip = anim[3];
                transform.GetComponent<Animation>().Play();

                PlayParallelSound(8, false);

                StartCoroutine(IrisEnum(anim[3].length));
            }
            irisMoving = true;
        }
    }

    IEnumerator IrisEnum(float len)
    {
        yield return new WaitForSeconds(len);

        irisMoving = false;
        irisOpen = !irisOpen;
    }

    public void ActivateGenerator()
    {
        activGen = !activGen;

        if (activGen)
        {
            activEPPZ = false;

            chevrons = new GameObject[chevronsS8.Length];
            chevrons = chevronsS8;

            lights = new GameObject[lightsS8.Length];
            lights = lightsS8;
        }
        else
        {
            chevrons = new GameObject[chevronsS7.Length];
            chevrons = chevronsS7;

            lights = new GameObject[lightsS7.Length];
            lights = lightsS7;
        }
}

    public void ActivateEPPZ()
    {
        activEPPZ = !activEPPZ;

        if (activEPPZ)
        {
            activGen = false;

            chevrons = new GameObject[chevronsS9.Length];
            chevrons = chevronsS9;

            lights = new GameObject[lightsS9.Length];
            lights = lightsS9;
        }
        else
        {
            chevrons = new GameObject[chevronsS7.Length];
            chevrons = chevronsS7;

            lights = new GameObject[lightsS7.Length];
            lights = lightsS7;
        }
    }
}
