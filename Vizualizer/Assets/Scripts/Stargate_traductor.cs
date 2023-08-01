using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;
using UnityEngine.UI;

public class Stargate_traductor : MonoBehaviour
{
    public TMP_Text toTranslate;
    public TMP_Text translated;

    public bool autoTranslate = false;
    bool isTranslated = false;

    public void Update()
    {
        if (autoTranslate == true)
        {
            if (isTranslated == false)
            {
                TranslateMyText();
            }
        }
    }

    public void TranslateMyText()
    {
        translated.text = toTranslate.text;
        isTranslated = true;
    }

    public void ChangeTextSource(TMP_Text newTextSource)
    {
        translated.text = "";
        toTranslate = newTextSource;
        isTranslated = false;
    }

    public void AutoTranslateMyText()
    {
        autoTranslate = !autoTranslate;
    }
}
