using System;
using UnityEngine;

public class sc_PodRacerEngine : MonoBehaviour
{
	[Header("Speeds")]
	[SerializeField]
	private float _linearSpeed = 10f;

	[SerializeField]
	private float _linearTurboSpeed = 10000f;

	[Header("Rotation")]
	[SerializeField]
	private float _axialSpeed = 10f;

	[SerializeField]
	private float _rollSpeed = 10f;

	[Header("Brake")]
	[SerializeField]
	private float _brakeForce = 10f;

	[Header("Maths")]
	[SerializeField]
	private float _hoverForce = 10f;

	[SerializeField]
	private float _hoverHeight = 2f;

	[SerializeField]
	private float _deadZone = 0.1f;

	[Header("New Gravity")]
	[SerializeField]
	private float _newGravity = 15f;

	[SerializeField]
	private float _wavingCorrection = 0.5f;

	[Header("Hover Points")]
	[SerializeField]
	private GameObject[] _hoverPoints;

	[Header("Camera Offset")]
	[SerializeField]
	private Transform _camOffset;

	[SerializeField]
	private float _CameraLinearSmooth = 0.005f;

	[SerializeField]
	private float _CameraAxialSmooth = 0.01f;

	[Header("Skin")]
	[SerializeField]
	private Transform _skin;

	[SerializeField]
	private Transform _maxR;

	[SerializeField]
	private Transform _maxL;

	[Header("Reactor Particles")]
	[SerializeField]
	private Transform[] _LeftFXArray;

	[SerializeField]
	private Transform[] _RightFXArray;

	[SerializeField]
	private Transform[] _MiddleFXArray;

	[SerializeField]
	private float _PropInertia = 500.0f;

	private Rigidbody rb;

	private Vector3 vel;

	private float yRotValue;

	private float currentThrust;

	private float currentTurn;

	private int _layerMask;

	private float linearSetSpeed;

	private float _hoverHeightSet;

	private float skinRotZ = 0f;

	private float forwardValue = 0f;

	private float forwardBoostValue = 0f;

	private float backwardValue = 0f;

	private float leftValue = 0f;

	private float rightValue = 0f;

	private void Start()
	{
		linearSetSpeed = _linearSpeed;
		this._hoverHeightSet = this._hoverHeight;
		Physics.gravity = new Vector3(0f, -this._newGravity, 0f);
		this.rb = base.GetComponent<Rigidbody>();
		this._layerMask = 1 << (LayerMask.NameToLayer("Pods") & 31);
		this._layerMask = ~this._layerMask;
	}

	private void Update()
	{
		ShipMovement();
		ShipSecondaryMovements();
		FXGestion();
	}

	private void FixedUpdate()
	{
		RaycastHit raycastHit;
		for (int i = 0; i < (int)this._hoverPoints.Length; i++)
		{
			GameObject go = this._hoverPoints[i];
			if (Physics.Raycast(go.transform.position, -go.transform.up, out raycastHit, this._hoverHeight, this._layerMask))
			{
				this.rb.AddForceAtPosition((go.transform.up * this._hoverForce) * (1f - raycastHit.distance / this._hoverHeight), go.transform.position);
			}
			this._camOffset.position = Vector3.Lerp(this._camOffset.position, base.transform.position, this._CameraLinearSmooth * Time.smoothDeltaTime);
			this._camOffset.rotation = Quaternion.Lerp(this._camOffset.rotation, base.transform.rotation, this._CameraAxialSmooth);
			this._hoverHeight = this._hoverHeightSet + Mathf.Abs(Mathf.Sin(Time.time) * this._wavingCorrection);
		}
		if (Mathf.Abs(this.currentThrust) > 0f)
		{
			this.rb.AddForce(base.transform.forward * this.currentThrust);
		}
		if (this.currentTurn > 0f)
		{
			this.rb.AddRelativeTorque((Vector3.up * this.currentTurn) * this._axialSpeed);
		}
		else if (this.currentTurn < 0f)
		{
			this.rb.AddRelativeTorque((Vector3.up * this.currentTurn) * this._axialSpeed);
		}
	}

	private void ShipMovement()
	{
		float axisRaw = Input.GetAxisRaw("Horizontal");
		float single = Input.GetAxisRaw("Vertical");

		this.currentTurn = 0f;

		if ((single > this._deadZone ? true : single < -this._deadZone))
		{
			this.currentThrust = single * this._linearSpeed;
		}
		if ((single >= this._deadZone ? false : single > -this._deadZone))
		{
			this.currentThrust = 0f;
		}

		if (single > this._deadZone)
		{
			this.forwardValue = 1f;
		}
		if (single < this._deadZone)
		{
			this.forwardValue = 0f;
		}

		if (Mathf.Abs(axisRaw) <= this._deadZone)
		{
			this._skin.GetChild(0).rotation = Quaternion.Lerp(this._skin.GetChild(0).rotation, base.transform.rotation, this._rollSpeed * 2f);
			this._skin.GetChild(1).rotation = Quaternion.Lerp(this._skin.GetChild(1).rotation, base.transform.rotation, this._rollSpeed);
			this.leftValue = 0f;
			this.rightValue = 0f;
		}
		else
		{
			this.currentTurn = axisRaw;
			if (axisRaw > 0f)
			{
				this._skin.GetChild(0).rotation = Quaternion.Lerp(this._skin.GetChild(0).rotation, this._maxR.rotation, this._rollSpeed);
				this._skin.GetChild(1).rotation = Quaternion.Lerp(this._skin.GetChild(1).rotation, this._maxR.rotation, this._rollSpeed / 2f);
				this.rightValue = 0.5f;
				this.leftValue = 0f;
			}
			if (axisRaw < 0f)
			{
				this._skin.GetChild(0).rotation = Quaternion.Lerp(this._skin.GetChild(0).rotation, this._maxL.rotation, this._rollSpeed);
				this._skin.GetChild(1).rotation = Quaternion.Lerp(this._skin.GetChild(1).rotation, this._maxL.rotation, this._rollSpeed / 2f);
				this.leftValue = 0.5f;
				this.rightValue = 0f;
			}
		}
	}

	private void ShipSecondaryMovements()
	{
		float roll = Input.GetAxis("Roll");

		if (Input.GetButton("Jump"))
		{
			this._linearSpeed = this._linearTurboSpeed;
			this.forwardBoostValue = 10f;
		}
		else
		{
			this._linearSpeed = this.linearSetSpeed;
			this.forwardBoostValue = 1f;
		}
		if (Input.GetButton("Sprint"))
		{
			this.rb.AddRelativeTorque((Vector3.right * this._axialSpeed) / 20f);
		}
		if (Input.GetButton("Crouch"))
		{
			this.rb.AddRelativeTorque((-Vector3.right * this._axialSpeed) / 20f);
		}

		this.rb.AddRelativeTorque(-Vector3.forward * roll * _rollSpeed * 10000);

		if(Input.GetButtonDown("noGrav"))
		{
			this.rb.useGravity = !this.rb.useGravity;
		}
	}

	private void FXGestion()
	{
		float single1 = (this.leftValue * 1.5f + this.forwardValue + this.backwardValue + this.forwardBoostValue - 1) / 2.5f;
		float single2 = (this.rightValue * 1.5f + this.forwardValue + this.backwardValue + this.forwardBoostValue - 1) / 2.5f;
		if (_LeftFXArray != null && _RightFXArray != null)
		{
			foreach (Transform _L in _LeftFXArray)
			{
				Animator LA = _L.GetComponent<Animator>();
				LA.SetFloat("FXBlend",Mathf.Lerp(LA.GetFloat("FXBlend"), single2, _PropInertia * this._rollSpeed * Time.smoothDeltaTime));
			}
			foreach (Transform _R in _RightFXArray)
			{
				Animator RA = _R.GetComponent<Animator>();
				RA.SetFloat("FXBlend",Mathf.Lerp(RA.GetFloat("FXBlend"), single1, _PropInertia * this._rollSpeed * Time.smoothDeltaTime));
			}
			//ParticlesOnly
			//this._L.localScale = new Vector3(1f, 1f, Mathf.Lerp(this._L.localScale.z, single2, 500f * this._rollSpeed * Time.smoothDeltaTime));
			//this._R.localScale = new Vector3(1f, 1f, Mathf.Lerp(this._R.localScale.z, single1, 500f * this._rollSpeed * Time.smoothDeltaTime));
		}
		if (_MiddleFXArray != null)
		{
			foreach (Transform _M in _MiddleFXArray)
			{
				Animator MA = _M.GetComponent<Animator>();
				MA.SetFloat("FXBlend",Mathf.Lerp(MA.GetFloat("FXBlend"), single1 + single2, _PropInertia * this._rollSpeed * Time.smoothDeltaTime));
			}
		}
	}

	private void OnDrawGizmos()
	{
		RaycastHit raycastHit;
		for (int i = 0; i < (int)this._hoverPoints.Length; i++)
		{
			GameObject go = this._hoverPoints[i];
			if (!Physics.Raycast(go.transform.position, -go.transform.up, out raycastHit, this._hoverHeight, this._layerMask))
			{
				Gizmos.color = Color.red;
				Gizmos.DrawLine(go.transform.position, go.transform.position - (go.transform.up * this._hoverHeight));
			}
			else
			{
				Gizmos.color = Color.blue;
				Gizmos.DrawLine(go.transform.position, raycastHit.point);
				Gizmos.DrawSphere(raycastHit.point, 0.5f);
			}
		}
	}
}