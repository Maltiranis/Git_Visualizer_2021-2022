using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;

public class sc_RacingUI : MonoBehaviour
{
    [SerializeField] private Transform speedTextual;
    private string speed = "0000";
    private Rigidbody rb;

    // Start is called before the first frame update
    void Start()
    {
        //speedTextual = transform.GetChild(0).transform.GetChild(1);
        rb = transform.parent.GetComponent<Rigidbody>();
    }

    // Update is called once per frame
    void Update()
    {
        int sum;

        sum = Mathf.RoundToInt(rb.velocity.magnitude * 20 * 0.621371f);
        speed = sum.ToString();

        speedTextual.GetComponent<TextMeshProUGUI>().text = speed;
    }
}
