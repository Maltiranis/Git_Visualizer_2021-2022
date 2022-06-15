using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class Save_RGB_and_Position : MonoBehaviour
{
    public Slider slidR;
    public Slider slidG;
    public Slider slidB;
    public Slider slidX;

    public Slider slidScale;

    public Slider slidForce;

    public float myPosX;
    public float myPosY;
    public float myPosZ;

    Vector3 loadedPos;
    float loadedScale;
    float loadedForce;
    Vector4 MyColor;

    void Start()
    {
        LoadPosition();
        //LoadScale();
        LoadForce();
        LoadColors();

        StartCoroutine(selfsaving());
    }

    IEnumerator selfsaving()
    {
        yield return new WaitForSeconds(1);

        PlayerPrefs.SetFloat("slidR", slidR.value);
        PlayerPrefs.SetFloat("slidG", slidG.value);
        PlayerPrefs.SetFloat("slidB", slidB.value);
        PlayerPrefs.SetFloat("slidX", slidX.value);

        PlayerPrefs.SetFloat("myPosX", transform.position.x);
        PlayerPrefs.SetFloat("myPosY", transform.position.y);
        PlayerPrefs.SetFloat("myPosZ", transform.position.z);

        PlayerPrefs.SetFloat("myScale", slidScale.value);

        PlayerPrefs.Save();

        StartCoroutine(selfsaving());
    }

    void LoadColors()
    {
        if (PlayerPrefs.HasKey("slidR") && PlayerPrefs.HasKey("slidG") && PlayerPrefs.HasKey("slidB") && PlayerPrefs.HasKey("slidX"))
        {
            if (!AreEqual(slidR.value, PlayerPrefs.GetFloat("slidR")) ||
                !AreEqual(slidG.value, PlayerPrefs.GetFloat("slidG")) ||
                !AreEqual(slidB.value, PlayerPrefs.GetFloat("slidB")) ||
                !AreEqual(slidX.value, PlayerPrefs.GetFloat("slidX")))
            {
                MyColor = new Vector4
                (
                    PlayerPrefs.GetFloat("slidR"),
                    PlayerPrefs.GetFloat("slidG"),
                    PlayerPrefs.GetFloat("slidB"),
                    PlayerPrefs.GetFloat("slidX")
                );
            }
            slidR.SetValueWithoutNotify(MyColor.x);
            slidG.SetValueWithoutNotify(MyColor.y);
            slidB.SetValueWithoutNotify(MyColor.z);
            slidX.SetValueWithoutNotify(MyColor.w);
        }
    }

    void LoadPosition()
    {
        if (PlayerPrefs.HasKey("myPosX") && PlayerPrefs.HasKey("myPosY") && PlayerPrefs.HasKey("myPosZ"))
        {
            if (!AreEqual(transform.position.x, PlayerPrefs.GetFloat("myPosX")) ||
                !AreEqual(transform.position.x, PlayerPrefs.GetFloat("myPosY")) ||
                !AreEqual(transform.position.x, PlayerPrefs.GetFloat("myPosZ")))
            {
                loadedPos = new Vector3
                (
                    PlayerPrefs.GetFloat("myPosX"),
                    PlayerPrefs.GetFloat("myPosY"),
                    PlayerPrefs.GetFloat("myPosZ")
                );
            }
            transform.position = loadedPos;
        }
    }

    void LoadScale()
    {
        if (PlayerPrefs.HasKey("myScale"))
        {
            if (!AreEqual(transform.localScale.x, PlayerPrefs.GetFloat("myScale")))
            {
                loadedScale = PlayerPrefs.GetFloat("myScale");
            }
            //slidScale.SetValueWithoutNotify(loadedScale);
            slidScale.value = loadedScale;
        }
    }

    void LoadForce()
    {
        if (PlayerPrefs.HasKey("myForce"))
        {
            if (!AreEqual(slidForce.value, PlayerPrefs.GetFloat("myForce")))
            {
                loadedForce = PlayerPrefs.GetFloat("myForce");
            }

            slidForce.value = loadedForce;
        }
    }

    bool AreEqual (float compared, float source)
    {
        if (compared != source)
            return false;
        else
            return true;
    }
}
