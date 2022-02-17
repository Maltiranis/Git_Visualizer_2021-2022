using System;
using UnityEngine;

public class sc_HyperSpace : MonoBehaviour
{
	[SerializeField]
	private Transform _followed;

	[SerializeField]
	private float _smoothSpeed = 0.2f;

	[SerializeField]
	private int _frontierSpeed = 4;

	public sc_NoGravEngine nge;

	[SerializeField]
	private float _smoothHyperSpace = 2f;

	public GameObject _particleSoftHyperSpace;

	public GameObject _particleHardHyperSpace;

	private sc_ParticleControl spcS;

	private sc_ParticleControl spcH;

	public sc_HyperSpace()
	{
	}

	private void ParticleGestion()
	{
		ParticleSystem.MinMaxCurve minMaxCurve;
		if (this.spcS != null)
		{
			ParticleSystem.EmissionModule num = this.spcS.ps.emission;
			if (this.nge.speed <= (float)this.nge._WarpTransitionAt)
			{
				minMaxCurve = num.rateOverTime;
				num.rateOverTime = (float)Mathf.RoundToInt(Mathf.Lerp(minMaxCurve.Evaluate(1f), 0f, 1f));
				this.spcS.ChangeLinearVelOnZ(Mathf.RoundToInt(Mathf.Lerp((float)this.spcS.actualLinZVel, 0f, this._smoothHyperSpace)));
			}
			else
			{
				num.rateOverTime = 100f;
				this.spcS.ChangeLinearVelOnZ(Mathf.RoundToInt(Mathf.Lerp((float)this.spcS.actualLinZVel, -250f, this._smoothHyperSpace)));
			}
		}
		if (this.spcH != null)
		{
			ParticleSystem.EmissionModule emissionModule = this.spcH.ps.emission;
			if (this.nge.speed <= (float)this._frontierSpeed)
			{
				this.spcH.ChangeLinearVelOnZ(Mathf.RoundToInt(Mathf.Lerp((float)this.spcH.actualLinZVel, 0f, this._smoothHyperSpace)));
				this.spcH.ChangeRadialVel(Mathf.RoundToInt(Mathf.Lerp((float)this.spcH.actualRadialVel, 0f, this._smoothHyperSpace)));
				minMaxCurve = emissionModule.rateOverTime;
				emissionModule.rateOverTime = (float)Mathf.RoundToInt(Mathf.Lerp(minMaxCurve.Evaluate(1f), 0f, 1f));
			}
			else
			{
				emissionModule.rateOverTime = 10f;
				this.spcH.ChangeLinearVelOnZ(Mathf.RoundToInt(Mathf.Lerp((float)this.spcH.actualLinZVel, -150f, this._smoothHyperSpace)));
				this.spcH.ChangeRadialVel(Mathf.RoundToInt(Mathf.Lerp((float)this.spcH.actualRadialVel, 150f, this._smoothHyperSpace)));
			}
		}
	}

	private void Start()
	{
		if (this._particleSoftHyperSpace != null && this._particleSoftHyperSpace.GetComponent<sc_ParticleControl>() != null)
		{
			this.spcS = this._particleSoftHyperSpace.GetComponent<sc_ParticleControl>();
			this.spcS.ChangeLinearVelOnZ(0);
		}
		if (this._particleHardHyperSpace != null && this._particleHardHyperSpace.GetComponent<sc_ParticleControl>() != null)
		{
			this.spcH = this._particleHardHyperSpace.GetComponent<sc_ParticleControl>();
			this.spcH.ChangeLinearVelOnZ(0);
			this.spcH.ChangeRadialVel(0);
		}
	}

	private void Update()
	{
		base.transform.rotation = Quaternion.Lerp(base.transform.rotation, this._followed.rotation, this._smoothSpeed);
		this.ParticleGestion();
	}
}