using System;
using System.Collections;
using System.Collections.Generic;
using System.Diagnostics;
using System.Runtime.CompilerServices;
using UnityEngine;

public class sc_HuntingPlayer : MonoBehaviour
{
	[SerializeField]
	private string _huntedTag = "Player";

	[SerializeField]
	private GameObject _missile;

	[SerializeField]
	private float _attackRange = 1000f;

	[SerializeField]
	private float _attackSpeed = 10f;

	[SerializeField]
	private float _attackRate = 0.5f;

	[SerializeField]
	private float _damage = 5f;

	[SerializeField]
	private float _movementSpeed = 100f;

	[SerializeField]
	private float _rotSpeed = 100f;

	[SerializeField]
	private GameObject[] _weapons;

	private bool ticked = true;

	private GameObject[] hunteds;

	private GameObject[] avoideds;

	[SerializeField]
	private List<GameObject> nearest = new List<GameObject>();

	[SerializeField]
	private List<GameObject> avoidest = new List<GameObject>();

	private Rigidbody rb;

	public sc_HuntingPlayer()
	{
	}

	private GameObject GetClosest()
	{
		float single = Mathf.Infinity;
		GameObject item = null;
		for (int i = 0; i < this.nearest.Count; i++)
		{
			float single1 = 0f;
			if (this.nearest[i] != null)
			{
				single1 = Vector3.Distance(this.nearest[i].transform.position, base.transform.position);
			}
			if (single1 < single)
			{
				single = single1;
				if (this.nearest[i] != null)
				{
					item = this.nearest[i];
				}
			}
		}
		return item;
	}

	private void Start()
	{
		this.rb = base.GetComponent<Rigidbody>();
		base.StartCoroutine(this.Ticker());
		this.hunteds = GameObject.FindGameObjectsWithTag(this._huntedTag);
		this.avoideds = GameObject.FindGameObjectsWithTag("NamedEntitie");
		for (int i = 0; i < (int)this.hunteds.Length; i++)
		{
			if (!this.nearest.Contains(this.hunteds[i]))
			{
				this.nearest.Add(this.hunteds[i]);
			}
		}
		for (int j = 0; j < (int)this.avoideds.Length; j++)
		{
			if (!this.nearest.Contains(this.avoideds[j]))
			{
				this.nearest.Add(this.avoideds[j]);
			}
		}
	}

	private IEnumerator Ticker()
	{
		yield return new WaitForSeconds(this._attackRate);
		this.ticked = true;
		base.StartCoroutine(this.Ticker());
	}

	private void Update()
	{
		RaycastHit raycastHit;
		float single = Vector3.Distance(base.transform.position, this.GetClosest().transform.position);
		Vector3 closest = this.GetClosest().transform.position - base.transform.position;
		if (this.GetClosest().transform.tag == "NamedEntitie")
		{
			Rigidbody rigidbody = this.rb;
			rigidbody.velocity = rigidbody.velocity - (closest.normalized * this._movementSpeed);
		}
		if (single <= this._attackRange / 2f)
		{
			this.rb.velocity = Vector3.zero;
			int num = UnityEngine.Random.Range(0, 2);
			float single1 = UnityEngine.Random.Range(this._rotSpeed / 2f, this._rotSpeed);
			Vector3 vector3 = new Vector3((float)num * single1, (float)num * single1, (float)num * single1);
			this.rb.AddTorque(vector3, ForceMode.Force);
		}
		else
		{
			Rigidbody rigidbody1 = this.rb;
			rigidbody1.velocity = rigidbody1.velocity + (closest.normalized * this._movementSpeed);
			this.rb.AddTorque(Vector3.zero, ForceMode.Force);
		}
		for (int i = 0; i < (int)this._weapons.Length; i++)
		{
			this._weapons[i].SetActive(true);
			this._weapons[i].transform.LookAt(this.GetClosest().transform);
			if (Physics.Raycast(this._weapons[i].transform.position, this._weapons[i].transform.forward, out raycastHit, this._attackRange))
			{
				if (raycastHit.transform.tag == this._huntedTag)
				{
					if (this.ticked)
					{
						this.ticked = false;
						GameObject gameObject = UnityEngine.Object.Instantiate<GameObject>(this._missile, this._weapons[i].transform.position, this._weapons[i].transform.rotation);
						gameObject.GetComponent<sc_Projectile>().target = this.GetClosest().transform;
					}
				}
				else if (raycastHit.transform.gameObject.layer == 12)
				{
					if (this.ticked)
					{
						this.ticked = false;
						GameObject closest1 = UnityEngine.Object.Instantiate<GameObject>(this._missile, this._weapons[i].transform.position, this._weapons[i].transform.rotation);
						closest1.GetComponent<sc_Projectile>().target = this.GetClosest().transform;
					}
				}
			}
		}
	}
}