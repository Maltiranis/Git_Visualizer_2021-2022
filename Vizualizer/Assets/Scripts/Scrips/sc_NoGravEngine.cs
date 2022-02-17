using System;
using TMPro;
using UnityEngine;

public class sc_NoGravEngine : MonoBehaviour
{
	[SerializeField]
	private Transform _ObjectToControl;

	[SerializeField]
	private Transform _AttachedCamera;

	[SerializeField]
	private Transform _AttachedSpaceshipWeaponery;

	[SerializeField]
	[Space(20f)]
	private Transform _xRot;

	[SerializeField]
	private Transform _yRot;

	[SerializeField]
	private Transform _zRot;

	[SerializeField]
	private Transform _translationer;

	[SerializeField]
	private float _linearSpeed = 10f;

	[SerializeField]
	private float _warpValue = 1f;

	[SerializeField]
	public int _WarpTransitionAt = 10;

	[SerializeField]
	private float _axialSpeed = 10f;

	[SerializeField]
	private float _axialDeceleration = 10f;

	[SerializeField]
	private float _axialSmooth = 2f;

	[SerializeField]
	private float _linearSmooth = 2f;

	[SerializeField]
	private float _CameraLinearSmooth = 0.005f;

	[SerializeField]
	private float _CameraAxialSmooth = 0.01f;

	[SerializeField]
	private TextMeshProUGUI _speedDisplay;

	[SerializeField]
	private string _displaySubject = "Distortion ";

	[SerializeField]
	private string _substituteSubject = "Impultion ";

	private Vector3 vel;

	private Rigidbody rb;

	private float xRotValue;

	private float yRotValue;

	private float zRotValue;

	private float yMov;

	public float speed;

	private float tempXrot;

	private float tempYrot;

	private float tempZrot;

	private float compensator;

	private bool _freeCam = false;

	public sc_NoGravEngine()
	{
	}

	private void FixedUpdate()
	{
		this._ObjectToControl.transform.rotation = this._translationer.rotation;
		Vector3 vector3 = this.rb.velocity.normalized;
		if (this._AttachedCamera != null)
		{
			Vector3.Distance(this._AttachedCamera.position, this._translationer.position);
			if (!this._freeCam)
			{
				if (this.speed <= 10f)
				{
					this._AttachedCamera.transform.parent = base.transform.parent;
					this._AttachedCamera.position = Vector3.Lerp(this._AttachedCamera.position, this._translationer.position, this._CameraLinearSmooth * Time.smoothDeltaTime);
				}
				else
				{
					this._AttachedCamera.transform.parent = base.transform;
					this._AttachedCamera.transform.localPosition = new Vector3(0f, 0f, this._AttachedCamera.transform.localPosition.z);
				}
				this._AttachedCamera.rotation = Quaternion.Lerp(this._AttachedCamera.rotation, this._translationer.rotation, this._CameraAxialSmooth);
			}
		}
	}

	private void Movement()
	{
		Vector3 vector3;
		float axisRaw = Input.GetAxisRaw("Horizontal");
		float single = Input.GetAxisRaw("Vertical");
		if (Input.GetAxisRaw("Mouse ScrollWheel") > 0f)
		{
			this.speed += 1f;
		}
		if (Input.GetAxisRaw("Mouse ScrollWheel") < 0f)
		{
			this.speed -= 1f;
		}
		if (Input.GetButton("Jump"))
		{
			this.yMov = 1f;
		}
		else if (!Input.GetButton("Crouch"))
		{
			this.yMov = 0f;
		}
		else
		{
			this.yMov = -1f;
		}
		Vector3 vector31 = this._translationer.right * axisRaw;
		Vector3 vector32 = this._translationer.up * this.yMov;
		Vector3 vector33 = this._translationer.forward * single;
		float single1 = this._linearSpeed * this.speed;
		if (this.speed > (float)this._WarpTransitionAt)
		{
			vector3 = (vector31 + vector32) + vector33;
			this.vel = vector3.normalized + ((this._translationer.forward * single1) * Mathf.Pow(this._warpValue, this.speed - (float)this._WarpTransitionAt));
		}
		else
		{
			vector3 = (vector31 + vector32) + vector33;
			this.vel = vector3.normalized * single1;
		}
		if (Input.GetAxisRaw("Mouse X") == 0f)
		{
			this.tempYrot = Mathf.Lerp(this.tempYrot, 0f, this._axialDeceleration * Time.deltaTime);
			this.yRotValue = this.tempYrot;
		}
		else
		{
			this.tempYrot = Input.GetAxisRaw("Mouse X") * this._axialSpeed;
			this.yRotValue = Mathf.Lerp(this.yRotValue, this.tempYrot, this._axialSmooth * Time.deltaTime);
		}
		if (Input.GetAxisRaw("Mouse Y") == 0f)
		{
			this.tempXrot = Mathf.Lerp(this.tempXrot, 0f, this._axialDeceleration * Time.deltaTime);
			this.xRotValue = this.tempXrot;
		}
		else
		{
			this.tempXrot = -Input.GetAxisRaw("Mouse Y") * this._axialSpeed;
			this.xRotValue = Mathf.Lerp(this.xRotValue, this.tempXrot, this._axialSmooth * Time.deltaTime);
		}
		if (Input.GetButton("Left Roll"))
		{
			this.tempZrot = this._axialSpeed;
			this.zRotValue = Mathf.Lerp(this.zRotValue, this.tempZrot, this._axialSmooth * 2f * Time.deltaTime);
		}
		else if (!Input.GetButton("Right Roll"))
		{
			this.tempZrot = Mathf.Lerp(this.tempZrot, 0f, this._axialDeceleration * Time.deltaTime);
			this.zRotValue = this.tempZrot;
		}
		else
		{
			this.tempZrot = -this._axialSpeed;
			this.zRotValue = Mathf.Lerp(this.zRotValue, this.tempZrot, this._axialSmooth * 2f * Time.deltaTime);
		}
		this._xRot.localRotation = Quaternion.Euler(this.xRotValue, 0f, 0f);
		this._yRot.localRotation = Quaternion.Euler(0f, this.yRotValue, 0f);
		this._zRot.localRotation = Quaternion.Euler(0f, 0f, this.zRotValue);
		if (this.vel != Vector3.zero)
		{
			Vector3 vector34 = Vector3.Lerp(this.rb.velocity, this.vel, this._linearSmooth * Time.smoothDeltaTime);
			this.rb.AddForce(vector34, ForceMode.Force);
		}
		if (!this._freeCam)
		{
			this.rb.AddTorque(this._translationer.right * this.xRotValue, ForceMode.Force);
			this.rb.AddTorque(this._translationer.up * this.yRotValue, ForceMode.Force);
		}
		else
		{
			this._AttachedCamera.transform.Rotate((this._AttachedCamera.right * this.xRotValue) * 0.2f, Space.World);
			this._AttachedCamera.transform.Rotate((this._AttachedCamera.up * this.yRotValue) * 0.2f, Space.World);
		}
		this.rb.AddTorque(this._translationer.forward * this.zRotValue, ForceMode.Force);
	}

	private void Start()
	{
		this.rb = base.GetComponent<Rigidbody>();
	}

	private void Update()
	{
		float single;
		if (this._AttachedSpaceshipWeaponery != null)
		{
			if (!Input.GetMouseButton(0))
			{
				this._AttachedSpaceshipWeaponery.GetComponent<sc_SpaceshipWeaponery>()._fireWeapons = false;
			}
			else
			{
				this._AttachedSpaceshipWeaponery.GetComponent<sc_SpaceshipWeaponery>()._fireWeapons = true;
			}
		}
		if (!Input.GetMouseButton(1))
		{
			this._freeCam = false;
		}
		else
		{
			this._freeCam = true;
		}
		this.Movement();
		if (this._ObjectToControl != null)
		{
			this._ObjectToControl.transform.position = this._translationer.position;
		}
		if (this._speedDisplay != null)
		{
			if (this.speed > (float)this._WarpTransitionAt)
			{
				single = this.speed - 10f;
				this._speedDisplay.text = String.Concat(this._displaySubject, single.ToString());
			}
			else
			{
				TextMeshProUGUI textMeshProUGUI = this._speedDisplay;
				string str = this._substituteSubject;
				single = Math.Abs(this.speed);
				textMeshProUGUI.text = String.Concat(str, single.ToString());
			}
		}
		if (this._freeCam)
		{
			this._AttachedCamera.position = this._ObjectToControl.position;
		}
	}
}