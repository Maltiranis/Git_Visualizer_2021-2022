using System.Collections;
using TMPro;
using UnityEngine;
using UnityEngine.UI;

public class Stargate_DoorControl_v2 : MonoBehaviour
{
    [Header("DHD")]
    public GameObject tileDHDParent;
    GameObject[] tileDHD;
    //int[] tileID = {5, 9, 20, 4, 3, 21, 11, 37, 12, 34, 24, 29, 6, 38, 7, 22, 19, 1, 32, 36, 15, 39, 25, 2, 10, 17, 28, 14, 16, 18, 27, 30, 23, 8, 35, 26, 33, 31};
    public GameObject buttonActivation;
    public Material[] ActivatedTile;
    public Material[] DesactivatedTile;
    [Header("Keyboard")]
    public GameObject keysParent;
    GameObject[] keys;
    public Color ActivatedKey;
    public Color DesactivatedKey;

    [Header("Le disque tournant")]
    public Transform diskTransform;
    [Tooltip("La vitesse de rotation du disque en degrés par seconde.")]
    public float rotationSpeed = 90f; // Vitesse en degrés par seconde
    private int _numberOfParts = 39;
    private int _currentPart = 0; // La part actuellement pointée vers le haut
    private int _targetPart = -1; // La part cible vers laquelle le disque doit tourner
    private Quaternion _targetRotation;
    private bool _isRotating = false;

    [Header("Chevrons & Lights")]
    public GameObject chevronsAndLightsParent;
    GameObject[] chevrons;
    GameObject[] lights;
    [Header("Kawoosh & Vortex")]
    public GameObject kawoosh;
    public GameObject vortexObject;
    public GameObject vortexLight;

    [Header("Animations")]
    public AnimationClip[] anim;
    [Header("Sounds")]
    public AudioClip[] audioClip;
    public GameObject soundPrefab;

    [Header("Conditions")]
    public int triggeredChevrons = 0;
    public int maxChevrons = 7;
    public bool irisOpen = true;
    public bool isStatic = false;
    public bool activGen = false;
    public bool activEPPZ = false;
    public bool canOpenVortex = false;
    public bool vortexOpened = false;

    private void Start()
    {
        SetArrays();
        InitializeComponents();
    }

    void SetArrays()
    {
        keys = new GameObject[keysParent.transform.childCount];
        for (int i = 0; i < keysParent.transform.childCount; i++)
        {
            keys[i] = keysParent.transform.GetChild(i).gameObject;
        }
        tileDHD = new GameObject[tileDHDParent.transform.childCount];
        for (int i = 0; i < tileDHDParent.transform.childCount; i++)
        {
            tileDHD[i] = tileDHDParent.transform.GetChild(i).gameObject;
        }
        chevrons = new GameObject[chevronsAndLightsParent.transform.childCount];
        for (int i = 0; i < chevronsAndLightsParent.transform.childCount; i++)
        {
            chevrons[i] = chevronsAndLightsParent.transform.GetChild(i).gameObject;
        }
        lights = new GameObject[chevrons.Length];
        for (int i = 0; i < chevrons.Length; i++)
        {
            lights[i] = chevrons[i].transform.GetChild(2).gameObject;
        }
    }

    void InitializeComponents()
    {
        foreach (GameObject tile in tileDHD)
        {
            sc_Tools.SetNewMaterials(tile, DesactivatedTile);
        }
        foreach (GameObject key in keys)
        {
            sc_Tools.SetNewColor(key, DesactivatedKey);
        }
        sc_Tools.SetActiveGameObjects(lights, false);

        canOpenVortex = false;
        vortexOpened = false;
        triggeredChevrons = 0;
    }

    private void Update()
    {
        MouseInterractions();
        DoorRotation();
    }

    bool RMouseClick()
    {
        if (Input.GetMouseButtonDown(1))
        {
            return true;
        }
        return false;
    }

    bool LMouseClick()
    {
        if (Input.GetMouseButtonDown(0))
        {
            return true;
        }
        return false;
    }

    void MouseInterractions()
    {
        Ray ray = Camera.main.ScreenPointToRay(Input.mousePosition);
        RaycastHit hit;

        if (LMouseClick())
        {
            if (Physics.Raycast(ray, out hit, 500))
            {
                for (int i = 0; i < tileDHD.Length; i++)
                {
                    if (hit.transform.name == tileDHD[i].name)
                    {
                        if (triggeredChevrons >= maxChevrons || _isRotating)
                        {
                            return;
                        }
                        triggeredChevrons++;

                        sc_Tools.SetNewMaterials(tileDHD[i], ActivatedTile);

                        OnUseDHDTile(i);// -1 obligatoire

                        PlaySound(Random.Range(0, 7));
                    }
                }
                if (hit.transform.name == buttonActivation.name)
                {
                    if (triggeredChevrons == maxChevrons)
                    {
                        canOpenVortex = true;
                    }
                    else
                    {
                        canOpenVortex = false;
                    }

                    OnUseActivatorButton();
                }
            }
        }
    }

    void DoorRotation()
    {
        if (_isRotating)
        {
            diskTransform.localRotation = Quaternion.RotateTowards(diskTransform.localRotation, _targetRotation, rotationSpeed * Time.deltaTime);

            if (Quaternion.Angle(diskTransform.localRotation, _targetRotation) < 0.1f)
            {
                diskTransform.localRotation = _targetRotation;
                _isRotating = false;
                _currentPart = _targetPart;

                chevrons[triggeredChevrons-1].GetComponent<Animation>().Play();
                StartCoroutine(ChevronLight(chevrons[triggeredChevrons - 1].GetComponent<Animation>().clip.length, chevrons[triggeredChevrons - 1].transform.GetChild(2).gameObject));

                if (triggeredChevrons != maxChevrons)
                    chevrons[7-1].GetComponent<Animation>().Play();

                PlaySound(Random.Range(13,16));
            }
        }
    }

    IEnumerator ChevronLight(float delay, GameObject light)
    {
        yield return new WaitForSeconds(delay);
        light.SetActive(!light.activeSelf);
    }

    void OnUseDHDTile(int tileIndex)
    {
        RotateToPart(tileIndex);
    }

    void OnUseActivatorButton()
    {
        if (vortexOpened)
        {
            buttonActivation.transform.GetChild(0).GetChild(0).gameObject.SetActive(false);
            CloseDoor();
            StartCoroutine(ClosingDoorLatency(anim[1].length));
        }
        else
        {
            if (canOpenVortex)
            {
                buttonActivation.transform.GetChild(0).GetChild(0).gameObject.SetActive(true);
                OpenDoor();
                PlaySound(7);
            }
            else
            {
                buttonActivation.transform.GetChild(0).GetChild(0).gameObject.SetActive(false);

                PlaySound(8);
            }
        }
    }

    IEnumerator ClosingDoorLatency(float latency = 1.0f)
    {
        yield return new WaitForSeconds(latency);
        InitializeComponents();
    }

    public void OpenDoor()
    {
        PlaySound(9);

        kawoosh.SetActive(irisOpen);
        vortexLight.SetActive(irisOpen);

        vortexObject.GetComponent<Animation>().clip = anim[0];
        vortexObject.GetComponent<Animation>().Play();

        vortexOpened = true;
    }

    public void CloseDoor()
    {
        PlaySound(10);

        kawoosh.SetActive(irisOpen);
        vortexLight.SetActive(irisOpen);

        vortexObject.GetComponent<Animation>().clip = anim[1];
        vortexObject.GetComponent<Animation>().Play();
    }

    public void ForceOpenVortex()
    {
        EarthAddress();
        OpenDoor();
        StartCoroutine(SystemLatency(anim[0].length, true));
    }

    public void ForceCloseVortex()
    {
        CloseDoor();
        StartCoroutine(SystemLatency(anim[1].length, false));
        StartCoroutine(ClosingDoorLatency(anim[1].length));
    }

    public void EarthAddress()
    {
        sc_Tools.SetNewMaterials(tileDHD[27], ActivatedTile);
        sc_Tools.SetNewMaterials(tileDHD[25], ActivatedTile);
        sc_Tools.SetNewMaterials(tileDHD[4], ActivatedTile);
        sc_Tools.SetNewMaterials(tileDHD[37], ActivatedTile);
        sc_Tools.SetNewMaterials(tileDHD[10], ActivatedTile);
        sc_Tools.SetNewMaterials(tileDHD[28], ActivatedTile);
        sc_Tools.SetNewMaterials(tileDHD[0], ActivatedTile);
    }

    IEnumerator SystemLatency(float latency, bool open)
    {
        yield return new WaitForSeconds(latency);

        for (int i = 0; i < maxChevrons; i++)
        {
            chevrons[i].transform.GetChild(2).gameObject.SetActive(open);
        }
    }

    public void ActivateIris(Button btn)
    {
        btn.enabled = false;

        if (irisOpen == true)
        {
            transform.GetComponent<Animation>().clip = anim[2];
            transform.GetComponent<Animation>().Play();

            PlaySound(11);
            StartCoroutine(IrisLatency(anim[2].length, btn));
        }
        if (irisOpen == false)
        {
            transform.GetComponent<Animation>().clip = anim[3];
            transform.GetComponent<Animation>().Play();

            PlaySound(12);
            StartCoroutine(IrisLatency(anim[3].length, btn));
        }
    }

    IEnumerator IrisLatency(float latency, Button btn)
    {
        yield return new WaitForSeconds(latency);
        irisOpen = !irisOpen;
        btn.enabled = true;
    }

    public void ActivateGenerator()
    {
        activGen = !activGen;

        if (activGen)
        {
            if (activEPPZ)
            {
                maxChevrons = 9;
            }
            else
            {
                maxChevrons = 8;
            }
        }
        else
        {
            if (!activEPPZ)
            {
                maxChevrons = 7;
            }
        }
    }

    public void ActivateEPPZ()
    {
        activEPPZ = !activEPPZ;

        if (activEPPZ)
        {
            maxChevrons = 9;
        }
        else
        {
            if (activGen)
            {
                maxChevrons = 8;
            }
            else
            {
                maxChevrons = 7;
            }
        }
    }

    public void RotateToPart(int targetPart)
    {
        if (_isRotating)
        {
            return;
        }

        _targetPart = targetPart;

        float anglePerPart = 360f / _numberOfParts;
        float angleToRotateTo = -(_targetPart * anglePerPart);

        _targetRotation = Quaternion.Euler(angleToRotateTo, 0, 0);

        _isRotating = true;
    }

    #region tools

    public void PlaySound(int n)
    {
        GameObject soundObject = Instantiate(soundPrefab, transform);

        AudioSource loopsource = soundObject.GetComponent<AudioSource>();
        loopsource.clip = audioClip[n];
        loopsource.Play();

        DestroyTimer DT = soundObject.GetComponent<DestroyTimer>();
        DT.SetDestruction(loopsource.clip.length);
    }

    public int GetCurrentPart()
    {
        return _currentPart;
    }

    #endregion tools
}
