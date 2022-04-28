using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class line_AddPoints : MonoBehaviour
{
    LineRenderer lineRenderer;

    public Transform _startPos;
    public Transform _endPos;

    public int _lengthOfLineRenderer = 20;
    public float _widthMult = 0.05f;
    public float _speed = 0.05f;
    //public float _coef = 0.5f;

    void Start()
    {
        lineRenderer = GetComponent<LineRenderer>();
    }

    void Update()
    {
        lineRenderer.widthMultiplier = _widthMult;
        lineRenderer.positionCount = _lengthOfLineRenderer;

        //_endPos.position = new Vector3(_endPos.position.x, 0, _endPos.position.z);

        var points = new Vector3[_lengthOfLineRenderer];
        //var t = Time.time;

        float dist = Vector3.Distance(_startPos.position, _endPos.position);
        Vector3 dir = _endPos.position - _startPos.position;
        float portion = dist / _lengthOfLineRenderer;

        for (int i = 0; i < _lengthOfLineRenderer; i++)
        {
            points[i] = _startPos.position + dir.normalized * portion * (1+i);
            //points[i] = new Vector3(_startPos.position.x, _startPos.position.y, _startPos.position.z);
            //points[i] = new Vector3(i * 0.5f, Mathf.Sin(i + t * _speed), 0.0f);
        }

        lineRenderer.SetPositions(points);
        Debug.Log(dist);
    }
}