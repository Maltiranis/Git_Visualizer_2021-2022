using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;

public class sc_CurvedText : MonoBehaviour
{
    public string text = "";
    public GameObject characterPatern;
    public float angleSpace;
    public float newAngle;
    char tempChar;

    // Start is called before the first frame update
    void Start()
    {
        PlaceLetters();
        newAngle = characterPatern.transform.localEulerAngles.y*360;
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    void PlaceLetters()
    {
        for (int i = 0; i < text.Length; i++)
        {
            tempChar = text[i];
            newAngle = angleSpace * i;
            GameObject newIns = Instantiate(characterPatern, transform.localPosition, characterPatern.transform.rotation);
            newIns.transform.parent = transform;
            newIns.transform.localPosition = Vector3.zero;
            newIns.transform.Rotate(newIns.transform.up, newAngle);
            TextMeshProUGUI tmpu = newIns.GetComponentInChildren<TextMeshProUGUI>();
            tmpu.text = tempChar.ToString();
        }
    }
}
