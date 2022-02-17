using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class sc_ArrayActivateChance : MonoBehaviour
{
    [SerializeField] private GameObject[] _array;
    [Header("chance to 100")]
    [SerializeField] private float _chances;
    [SerializeField] private bool _repeating = true;
    [SerializeField] private float _repetitionTime = 1f;

    // Start is called before the first frame update
    void Start()
    {
        if (_array.Length == 0 || _array == null)
        {
            int cc = transform.childCount;
            _array = new GameObject[cc];

            for (int i = 0; i < cc; i++)
            {
                _array[i] = transform.GetChild(i).gameObject;
            }
        }

        StartCoroutine(Repeat());
        ChanceToArray();
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    void ChanceToArray()
    {
        /*foreach (var g in _array)
        {
            g.SetActive(false);
        }*/
        for (int i = 0; i < _array.Length; i++)
        {
            float rand = Random.Range(0f, 100f);
            if (rand <= _chances)
            {
                _array[i].SetActive(true);
            }
            else
            {
                _array[i].SetActive(false);
            }
        }
    }

    IEnumerator Repeat()
    {
        yield return new WaitForSeconds(_repetitionTime);

        ChanceToArray();

        if (_repeating)
        {
            StartCoroutine(Repeat());
        }
    }
}
