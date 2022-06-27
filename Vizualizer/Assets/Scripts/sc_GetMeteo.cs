using System.Collections.Generic;
using System.Collections;
using UnityEngine;
using TMPro;
using UnityEngine.Networking;
using System.IO;
using System.Linq;

public class sc_GetMeteo : MonoBehaviour
{
    [TextArea (10, 10)]
    public string textFromWWW;
    private string url = "https://weather.com/fr-FR/temps/aujour/l/7d6d3f6ca4633a40596d4624c65f780c32635fbf8233041ec8be134f9bee529b"; //url here
    //private string url = "https://www.google.com/search?q=meteo&rlz=1C1CHBF_frFR925FR947&biw=2133&bih=1041&sxsrf=ALiCzsa_YutVzxyzs_I7H-c0nYgq9_OMfg%3A1656329034910&ei=SpO5YtmKN-KAzgO5zYFA&ved=0ahUKEwjZ14a-ws34AhVigHMKHblmAAgQ4dUDCA4&uact=5&oq=meteo&gs_lcp=Cgdnd3Mtd2l6EAMyBAgAEEMyBwgAEMkDEEMyBQgAEJIDMgsIABCABBCxAxCDATIECAAQQzIECAAQAzIECAAQQzIRCC4QgAQQsQMQgwEQxwEQ0QMyBAgAEEMyBAgAEEM6BwgAEEcQsAM6BwgAELADEEM6CggAEOQCELADGAE6CggAELEDEIMBEEM6EAguELEDEIMBEMcBENEDEEM6DAgAEMkDEEMQRhCAAkoECEEYAEoECEYYAVDhCFiUEGClEmgDcAF4AIAB3AKIAa8GkgEHMi4xLjEuMZgBAKABAcgBEcABAdoBBggBEAEYCQ&sclient=gws-wiz"; //url here

    public string temperature;

    void Start()
    {
        StartCoroutine(GetTextFromWWW());
    }

    void SetVariables ()
    {
        if (textFromWWW.Contains)
            temperature = textFromWWW.
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
            StreamWriter writer = new StreamWriter("Assets/Resources/MeteoParser.txt", true);
            writer.Flush();
            writer.Write(textFromWWW);
            
            writer.Close();
        }
    }
}
