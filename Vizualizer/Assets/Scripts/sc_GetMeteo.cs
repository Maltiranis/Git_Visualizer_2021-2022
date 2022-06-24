using System.Collections;
using UnityEngine;
using TMPro;
using UnityEngine.Networking;

public class sc_GetMeteo : MonoBehaviour
{
    [TextArea (10, 10)]
    public string textFromWWW;
    private string url = "https://weather.com/fr-FR/temps/aujour/l/7d6d3f6ca4633a40596d4624c65f780c32635fbf8233041ec8be134f9bee529b"; // <-- enter your url here

    void Start()
    {
        StartCoroutine(GetTextFromWWW());
    }

    IEnumerator GetTextFromWWW()
    {
        WWW www = new WWW(url);

        yield return www;

        if (www.error != null)
        {
            Debug.Log("Ooops, something went wrong...");
        }
        else
        {
            textFromWWW = www.text;
        }
    }
}
