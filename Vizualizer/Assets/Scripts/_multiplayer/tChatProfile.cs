using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;
using System.IO;

public class tChatProfile : MonoBehaviour
{
    public TMP_InputField inputField;
    public GameObject content;

    public bool isSetted = false;

    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    public void MyOnEnterPressed ()
    {
        if (isSetted == false)
        {
            isSetted = true;
        }
    }
}
