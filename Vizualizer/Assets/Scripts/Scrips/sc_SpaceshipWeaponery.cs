using System;
using System.Collections;
using System.Collections.Generic;
using System.Diagnostics;
using System.Runtime.CompilerServices;
using UnityEngine;

public class sc_SpaceshipWeaponery : MonoBehaviour
{
	[SerializeField]
	private float _attackRange = 100f;

	[SerializeField]
	private float _lazerSpeed = 10f;

	[SerializeField]
	private float _lazerWidth = 0.5f;

	[SerializeField]
	private float _lazerTickRate = 0.5f;

	[SerializeField]
	private float _lazerDamage = 2f;

	[SerializeField]
	private float _missileDamage = 25f;

	[SerializeField]
	private float _missileSpeed = 100f;

	[SerializeField]
	private float _missileReload = 1f;

	[SerializeField]
	private GameObject _missile;

	[SerializeField]
	private GameObject _cam;

	[SerializeField]
	private GameObject[] _lazers;

	[SerializeField]
	private GameObject[] _missileType;

	private Vector3 rayHead;

	public bool _fireWeapons = false;

	[SerializeField]
	private LayerMask layerMask;

	private bool ticked = true;

	private bool coolDowned = true;

	private LineRenderer[] lrs;

	public sc_SpaceshipWeaponery()
	{
	}

	private IEnumerator CoolDown()
	{
		yield return new WaitForSeconds(this._missileReload);
		this.coolDowned = true;
	}

	public void MissileShoot()
	{
		if (this._fireWeapons)
		{
			if (this.coolDowned)
			{
				this.coolDowned = false;
				for (int i = 0; i < (int)this._missileType.Length; i++)
				{
					GameObject gameObject = UnityEngine.Object.Instantiate<GameObject>(this._missile, this._missileType[i].transform.position, this._cam.transform.rotation);
					gameObject.GetComponent<Rigidbody>().AddForce(this._missileType[i].transform.forward * this._missileSpeed, ForceMode.Impulse);
					gameObject.GetComponent<sc_Projectile>()._damages = this._missileDamage;
					base.StartCoroutine(this.CoolDown());
				}
			}
		}
	}

	public void Orientation()
	{
		RaycastHit raycastHit;
		RaycastHit raycastHit1;
		if (!Physics.Raycast(this._cam.transform.position, this._cam.transform.forward, out raycastHit, this._attackRange, this.layerMask))
		{
			this.rayHead = this._cam.transform.position + (this._cam.transform.forward * this._attackRange);
		}
		else
		{
			this.rayHead = raycastHit.point;
		}
		if (!Input.GetMouseButton(1))
		{
			LineRenderer[] lineRendererArray = this.lrs;
			for (int i = 0; i < (int)lineRendererArray.Length; i++)
			{
				LineRenderer lineRenderer = lineRendererArray[i];
				lineRenderer.SetPosition(0, lineRenderer.transform.position);
				lineRenderer.SetPosition(1, lineRenderer.transform.position);
				lineRenderer.widthMultiplier = 0f;
			}
			if (this._missileType.Length != 0)
			{
				this.MissileShoot();
			}
		}
		else if (this._lazers.Length != 0)
		{
			for (int j = 0; j < (int)this._lazers.Length; j++)
			{
				this._lazers[j].transform.LookAt(this.rayHead);
				this.lrs[j].SetPosition(0, this._lazers[j].transform.position);
				if (!Physics.Raycast(this._lazers[j].transform.position, this._lazers[j].transform.forward, out raycastHit1, this._attackRange))
				{
					this.lrs[j].SetPosition(1, this._lazers[j].transform.position);
				}
				else if (raycastHit1.collider.gameObject.layer.ToString() == "SpaceShip")
				{
					this.lrs[j].SetPosition(1, this._lazers[j].transform.position);
				}
				else if (!this._fireWeapons)
				{
					this.lrs[j].SetPosition(1, this._lazers[j].transform.position);
					this.lrs[j].widthMultiplier = 0f;
				}
				else
				{
					this.lrs[j].useWorldSpace = true;
					this.lrs[j].SetPosition(1, this.rayHead);
					this.lrs[j].widthMultiplier = this._lazerWidth;
					if (this.ticked)
					{
						this.ticked = false;
						if (raycastHit1.collider.gameObject.GetComponent<sc_LifeEngine>() != null)
						{
							raycastHit1.collider.gameObject.GetComponent<sc_LifeEngine>().TakeDamage(this._lazerDamage);
						}
					}
				}
			}
		}
	}

	private void Start()
	{
		this.layerMask = ~(1 << (LayerMask.NameToLayer("SpaceShip") & 31));
		base.StartCoroutine(this.Ticker());
		this.lrs = new LineRenderer[(int)this._lazers.Length];
		for (int i = 0; i < (int)this._lazers.Length; i++)
		{
			this.lrs[i] = this._lazers[i].transform.GetComponent<LineRenderer>();
		}
	}

	private IEnumerator Ticker()
	{
		yield return new WaitForSeconds(this._lazerTickRate);
		this.ticked = true;
		base.StartCoroutine(this.Ticker());
	}

	private void Update()
	{
		this.Orientation();
	}
}