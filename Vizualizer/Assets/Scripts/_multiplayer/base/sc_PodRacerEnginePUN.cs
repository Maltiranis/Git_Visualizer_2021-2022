using Photon.Pun;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class sc_PodRacerEnginePUN : MonoBehaviourPun
{
    [Header("Solo/Multi")]
    [SerializeField] private bool _enablePUN = true;
    [Header("Speeds")]
    [SerializeField] public float _linearSpeed = 25000f;
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
    [SerializeField] private float _wavingCorrection = 0.02f;
    [Header("Hover Points")]
    [SerializeField] private GameObject _Points;
    GameObject[] _hoverPoints;
    [Header("Camera Offset")]
    [SerializeField] private Transform _camOffset;
    [SerializeField] private float _CameraLinearSmooth = 7f;
    [SerializeField] private float _CameraAxialSmooth = 0.01f;
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

    private PhotonView PV;

    // Start is called before the first frame update
    void Start()
    {
        if (_enablePUN)
        {
            PV = GetComponent<PhotonView>();
            PV.ObservedComponents.Add(_skin.transform.GetChild(0).GetComponent<PhotonTransformView>());
            PV.ObservedComponents.Add(_skin.transform.GetChild(1).GetComponent<PhotonTransformView>());

            gameObject.name = PV.Owner.NickName;
        }
        _L = _skin.GetComponent<sc_TransformStack>().myStack[0];
        _R = _skin.GetComponent<sc_TransformStack>().myStack[1];
        rb = GetComponent<Rigidbody>();

        _hoverPoints = new GameObject[_Points.transform.childCount];
        for (int i = 0; i < _hoverPoints.Length; i++)
        {
            _hoverPoints[i] = _Points.transform.GetChild(i).gameObject;
        }

        if (_enablePUN && !PV.IsMine)
        {
            rb.isKinematic = true;
            _camOffset.gameObject.SetActive(false);
            return;
        }

        _camOffset.parent = null;
        linearSetSpeed = _linearSpeed;
        _hoverHeightSet = _hoverHeight;

        _layerMask = 1 << LayerMask.NameToLayer("Pods");
        _layerMask = ~_layerMask;
    }

    // Update is called once per frame
    void Update()
    {
        if (_enablePUN && !PV.IsMine)// faire code qui change l'angle et la hauteur/sol
        {
            return;
        }
        float xMov = Input.GetAxisRaw("RightLeft") + Input.GetAxis("LJoyHorizontal_0");
        float zMov = Input.GetAxisRaw("ForwardBackward") + Input.GetAxis("RT_0") - Input.GetAxis("LT_0");

        if (Input.GetButton("Jump") || Input.GetButton("RB_0"))
        {
            _linearSpeed = _linearTurboSpeed;
            forwardBoostValue = 1.0f;
        }
        else
        {
            _linearSpeed = linearSetSpeed;
            forwardBoostValue = 0.0f;
        }

        if (Input.GetButton("Sprint") || Input.GetButton("xA_0"))
        {
            rb.AddRelativeTorque(Vector3.right * _axialSpeed / 20);
        }
        else
        {
            rb.AddRelativeTorque(Vector3.right * _axialSpeed / 50);
        }

        if (Input.GetButton("Crouch") || Input.GetButton("xB_0"))
        {
            rb.AddRelativeTorque(-Vector3.right * _axialSpeed / 25);
        }

        //Linear move
        currentThrust = 0.0f;

        if (zMov > _deadZone || zMov < -_deadZone)
        {
            currentThrust = zMov * _linearSpeed;
        }
        if (zMov < _deadZone && zMov > -_deadZone)
        {

        }
        if (zMov > _deadZone)
            forwardValue = 1f;
        if (zMov < _deadZone)
            forwardValue = 0f;

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
        if (_enablePUN && !PV.IsMine)
        {
            return;
        }
        //Hover motor
        if (_hoverPoints[0] == null)
        {
            _hoverPoints = new GameObject[_Points.transform.childCount];
            for (int i = 0; i < _hoverPoints.Length; i++)
            {
                _hoverPoints[i] = _Points.transform.GetChild(i).gameObject;
            }
        }
        RaycastHit hit;
        for (int i = 0; i < _hoverPoints.Length; i++)
        {
            GameObject hoverPoint = _hoverPoints[i];
            if (Physics.Raycast(hoverPoint.transform.position, -Vector3.up, out hit, _hoverHeight, _layerMask))
            {
                rb.AddForceAtPosition(Vector3.up * _hoverForce * (1.0f - (hit.distance / _hoverHeight)), hoverPoint.transform.position);
            }

            //Camera
            _camOffset.position = Vector3.Lerp(_camOffset.position, transform.position, _CameraLinearSmooth * Time.smoothDeltaTime);
            _camOffset.rotation = Quaternion.Lerp(_camOffset.rotation, transform.rotation, _CameraAxialSmooth);

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

    public void OnPhotonSerializeView(PhotonStream stream, PhotonMessageInfo info)
    {
        if (stream.IsWriting)
        {
            stream.SendNext(rb.position);
            stream.SendNext(rb.rotation);
            stream.SendNext(rb.velocity);
            stream.SendNext(_skin.transform.GetChild(0).transform.position);
            stream.SendNext(_skin.transform.GetChild(0).transform.rotation);
            stream.SendNext(_skin.transform.GetChild(1).transform.position);
            stream.SendNext(_skin.transform.GetChild(1).transform.rotation);
        }
        else
        {
            rb.position = _skin.transform.GetChild(0).transform.position;

            rb.position = (Vector3)stream.ReceiveNext();
            rb.rotation = (Quaternion)stream.ReceiveNext();
            rb.velocity = (Vector3)stream.ReceiveNext();
            _skin.transform.GetChild(0).transform.position = (Vector3)stream.ReceiveNext();
            _skin.transform.GetChild(0).transform.rotation = (Quaternion)stream.ReceiveNext();
            _skin.transform.GetChild(1).transform.position = (Vector3)stream.ReceiveNext();
            _skin.transform.GetChild(1).transform.rotation = (Quaternion)stream.ReceiveNext();

            float lag = Mathf.Abs((float)(PhotonNetwork.Time - info.SentServerTime));
            rb.position += rb.velocity * lag;
        }
    }

    /*void OnDrawGizmos()
    {
        RaycastHit hit;
        for (int i = 0; i < _hoverPoints.Length; i++)
        {
            GameObject hoverPoint = _hoverPoints[i];
            if (Physics.Raycast(hoverPoint.transform.position, -Vector3.up, out hit, _hoverHeight, _layerMask))
            {
                Gizmos.color = Color.blue;
                Gizmos.DrawLine(hoverPoint.transform.position, hit.point);
                Gizmos.DrawSphere(hit.point, 0.5f);
            }
            else
            {
                Gizmos.color = Color.red;
                Gizmos.DrawLine(hoverPoint.transform.position, hoverPoint.transform.position - Vector3.up * _hoverHeight);
            }
        }
    }*/
}
