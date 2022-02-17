using System;
using System.Collections.Generic;
using TMPro;
using UnityEngine;

public class sc_GravityStrates : MonoBehaviour
{
	[SerializeField]
	private float _impulseFreq = 1f;

	[SerializeField]
	private float _detectionRadius = 100000f;

	[SerializeField]
	private Transform _boussole;

	[SerializeField]
	private Transform _transformVectorsGet;

	[SerializeField]
	private GameObject _aimingCanvas;

	public GameObject[] _namedEntitie;

	public List<GameObject> _aims = new List<GameObject>();

	private float timer;

	private char separator = '\u005F';

	public sc_GravityStrates()
	{
	}

	private void LaunchDetection()
	{
		for (int i = 0; i < (int)this._namedEntitie.Length; i++)
		{
			if (Vector3.Distance(this._namedEntitie[i].transform.position, this._boussole.position) <= this._detectionRadius)
			{
				if (Int32.TryParse(this._aims[i].name.Split(new Char[] { this.separator })[1], out i))
				{
					this._aims[i].SetActive(true);
				}
			}
		}
	}

	private void Start()
	{
		this._namedEntitie = GameObject.FindGameObjectsWithTag("NamedEntitie");
		for (int i = 0; i < (int)this._namedEntitie.Length; i++)
		{
			GameObject vector3 = UnityEngine.Object.Instantiate<GameObject>(this._aimingCanvas, this._boussole.position, Quaternion.identity);
			vector3.name = String.Concat("Aim_", i.ToString());
			vector3.transform.GetChild(0).transform.GetChild(0).GetComponent<TextMeshProUGUI>().text = this._namedEntitie[i].name;
			vector3.transform.parent = base.transform;
			vector3.layer = 9;
			vector3.transform.localScale = new Vector3(1f, 1f, 1f);
			vector3.transform.localPosition = new Vector3(0f, 0f, 0f);
			vector3.SetActive(false);
			this._aims.Add(vector3);
		}
	}

	private void Update()
	{
		this.timer += Time.deltaTime;
		if (this.timer >= this._impulseFreq)
		{
			foreach (GameObject _aim in this._aims)
			{
				_aim.SetActive(false);
			}
			for (int i = 0; i < (int)this._namedEntitie.Length; i++)
			{
				this._aims[i].transform.LookAt(this._namedEntitie[i].transform);
				this._aims[i].transform.GetChild(0).rotation = this._transformVectorsGet.rotation;
			}
			this.LaunchDetection();
		}
	}
}