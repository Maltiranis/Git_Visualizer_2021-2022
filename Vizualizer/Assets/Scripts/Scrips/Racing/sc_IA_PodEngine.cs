using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class sc_IA_PodEngine : MonoBehaviour
{
    [Header("Speeds")]
    [SerializeField] private float _linearSpeed = 25000f;
    [SerializeField] private float _linearTurboSpeed = 50000f;
    [Header("Rotation")]
    [SerializeField] private float _axialSpeed = 1500f;
    [SerializeField] private float _rollSpeed = 0.008f;
    [Header("Brake")]
    [SerializeField] private float _brakeForce = 10.0f;
    [Header("Maths")]
    [SerializeField] private float _hoverForce = 10000f;
    [SerializeField] private float _hoverHeight = 1f;
    [SerializeField] private float _deadZone = 0.2f;
    [Header("New Gravity")]
    [SerializeField] private float _newGravity = 100f;
    [SerializeField] private float _wavingCorrection = 0.02f;
    [Header("Hover Points Container")]
    [SerializeField] private GameObject _Points;
    GameObject[] _hoverPoints;
    [Header("Skin")]
    public GameObject _skin;
    [SerializeField] private Transform _maxR;
    [SerializeField] private Transform _maxL;
    [Header("Reactor Particles")]
    private Transform _L;
    private Transform _R;

    Rigidbody rb;
    Vector3 vel;
    float yRotValue;
    float currentThrust;
    float currentTurn;
    int _layerMask;
    float linearSetSpeed;
    float _hoverHeightSet;
    float skinRotZ = 0f;
    float forwardValue = 0f;
    float forwardBoostValue = 0f;
    float backwardValue = 0f;
    float leftValue = 0f;
    float rightValue = 0f;

    public GameObject[] others;
    public GameObject _reachGoal;
    public GameObject _Goals;
    public GameObject[] _GoalTab;
    Transform boussole;
    int currentGoal = 0;
    public float _repulseForce = 20000f;
    public float _minProximityDist = 5f;

    public float xMov = 0f;
    public float zMov = 0f;

    // Start is called before the first frame update
    void Start()
    {
        others = GameObject.FindGameObjectsWithTag("IA");

        _GoalTab = new GameObject[_Goals.transform.childCount];
        for (int i = 0; i < _GoalTab.Length; i++)
        {
            _GoalTab[i] = _Goals.transform.GetChild(i).gameObject;
        }

        _reachGoal = _GoalTab[currentGoal];
        boussole = transform.GetChild(0);
        _hoverPoints = new GameObject[_Points.transform.childCount];
        for (int i = 0; i < _hoverPoints.Length; i++)
        {
            _hoverPoints[i] = _Points.transform.GetChild(i).gameObject;
        }

        _L = _skin.GetComponent<sc_TransformStack>().myStack[0];
        _R = _skin.GetComponent<sc_TransformStack>().myStack[1];
        rb = GetComponent<Rigidbody>();

        linearSetSpeed = _linearSpeed;
        _hoverHeightSet = _hoverHeight;

        Physics.gravity = new Vector3(0f, -_newGravity, 0f);

        _layerMask = 1 << LayerMask.NameToLayer("Pods");
        _layerMask = ~_layerMask;
    }

    // Update is called once per frame
    void Update()
    {
        foreach (var o in others)
        {
            float dist = Vector3.Distance(o.transform.position, transform.position);
            if (dist < _minProximityDist)
            {
                Vector3 invDir = (o.transform.position - transform.position).normalized;
                rb.AddForce(-invDir * _repulseForce, ForceMode.Force);
            }
        }

        boussole.LookAt(_reachGoal.transform);

        //Change to next checkpoint
        if (Vector3.Distance(_reachGoal.transform.position, transform.position) < 10f)
        {
            if (currentGoal < _GoalTab.Length-1)
                currentGoal++;
            else
                currentGoal = 0;
            _reachGoal = _GoalTab[currentGoal];
        }

        Vector3 dir = _reachGoal.transform.position - transform.position;

        if (Vector3.Dot(transform.right, dir) < 0f &&
            Vector3.Angle(transform.forward, boussole.forward) > 5f)
        {
            xMov = Mathf.Lerp(xMov, -1, _axialSpeed / 100 * Time.smoothDeltaTime);
        }
        else if (Vector3.Dot(transform.right, dir) > 0f &&
            Vector3.Angle(transform.forward, boussole.forward) > 5f)
        {
            xMov = Mathf.Lerp(xMov, 1, _axialSpeed / 100 * Time.smoothDeltaTime);
        }
        else
        {
            xMov = Mathf.Lerp(xMov, 0, _axialSpeed * Time.smoothDeltaTime);
        }

        zMov = 1f;
        float turboChance = Random.Range(0f, 100f);
        if (turboChance > 70f)
        {
            _linearSpeed = _linearTurboSpeed;
            forwardBoostValue = 1.0f;
        }
        else
        {
            _linearSpeed = linearSetSpeed;
            forwardBoostValue = 0.0f;
        }

        /*if (Input.GetButton("Sprint") || Input.GetButton("xA_0"))
        {
            rb.AddRelativeTorque(Vector3.right * _axialSpeed / 5);
        }
        else
        {
            rb.AddRelativeTorque(Vector3.right * _axialSpeed / 10);
        }

        if (Input.GetButton("Crouch") || Input.GetButton("xB_0"))
        {
            rb.AddRelativeTorque(-Vector3.right * _axialSpeed / 15);
        }*/

        //Linear move
        currentThrust = 0.0f;

        currentThrust = zMov * _linearSpeed;

        forwardValue = 1f;

        //Axial move
        currentTurn = 0.0f;

        if (Mathf.Abs(xMov) > _deadZone)
        {
            currentTurn = xMov;
            //faire tourner le _skin

            if (xMov > 0f)
            {
                _skin.transform.GetChild(0).rotation = Quaternion.Lerp(_skin.transform.GetChild(0).rotation, _maxR.rotation, _rollSpeed);
                _skin.transform.GetChild(1).rotation = Quaternion.Lerp(_skin.transform.GetChild(1).rotation, _maxR.rotation, _rollSpeed / 2);
                rightValue = 0.5f;
                leftValue = 0.0f;
            }
            if (xMov < 0f)
            {
                _skin.transform.GetChild(0).rotation = Quaternion.Lerp(_skin.transform.GetChild(0).rotation, _maxL.rotation, _rollSpeed);
                _skin.transform.GetChild(1).rotation = Quaternion.Lerp(_skin.transform.GetChild(1).rotation, _maxL.rotation, _rollSpeed / 2);
                leftValue = 0.5f;
                rightValue = 0.0f;
            }
        }
        else
        {
            _skin.transform.GetChild(0).rotation = Quaternion.Lerp(_skin.transform.GetChild(0).rotation, transform.rotation, _rollSpeed * 2);
            _skin.transform.GetChild(1).rotation = Quaternion.Lerp(_skin.transform.GetChild(1).rotation, transform.rotation, _rollSpeed);
            leftValue = 0.0f;
            rightValue = 0.0f;
        }

        //Inverted for a reason
        float leftCalcul = 0.01f + leftValue + forwardValue + backwardValue + forwardBoostValue;
        float rightCalcul = 0.01f + rightValue + forwardValue + backwardValue + forwardBoostValue;
        foreach (Transform t in _L)
        {
            t.localScale = new Vector3(1, 1, Mathf.Lerp(t.localScale.z, rightCalcul, 500 * _rollSpeed * Time.smoothDeltaTime));
        }
        foreach (Transform tt in _R)
        {
            tt.localScale = new Vector3(1, 1, Mathf.Lerp(tt.localScale.z, leftCalcul, 500 * _rollSpeed * Time.smoothDeltaTime));
        }
    }

    private void FixedUpdate()
    {
        //Hover motor
        RaycastHit hit;
        for (int i = 0; i < _hoverPoints.Length; i++)
        {
            GameObject hoverPoint = _hoverPoints[i];
            if (Physics.Raycast(hoverPoint.transform.position, -Vector3.up, out hit, _hoverHeight, _layerMask))
            {
                rb.AddForceAtPosition(Vector3.up * _hoverForce * (1.0f - (hit.distance / _hoverHeight)), hoverPoint.transform.position);
            }

            //Smooth sin hover
            _hoverHeight = _hoverHeightSet + Mathf.Abs(Mathf.Sin(Time.time) * _wavingCorrection);
        }

        //Moving forward
        if (Mathf.Abs(currentThrust) > 0)
        {
            rb.AddForce(transform.forward * currentThrust);
        }

        //Turning
        if (currentTurn > 0)
        {
            rb.AddRelativeTorque(Vector3.up * currentTurn * _axialSpeed);
        }
        else if (currentTurn < 0)
        {
            rb.AddRelativeTorque(Vector3.up * currentTurn * _axialSpeed);
        }
    }
}
