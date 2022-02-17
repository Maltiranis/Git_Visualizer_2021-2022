using System;
using UnityEngine;

public class sc_ParticleControl : MonoBehaviour
{
	public ParticleSystem ps;

	private ParticleSystem.VelocityOverLifetimeModule vel;

	public int actualLinZVel;

	public int actualRadialVel;

	public void ChangeLinearVelOnZ(int newVel)
	{
		this.vel = this.ps.velocityOverLifetime;
		this.vel.z = (float)newVel;
	}

	public void ChangeRadialVel(int newVel)
	{
		this.vel.radial = (float)newVel;
	}

	private void Start()
	{
		this.ps = base.GetComponent<ParticleSystem>();
	}

	private void Update()
	{
		ParticleSystem.MinMaxCurve minMaxCurve = this.vel.z;
		this.actualLinZVel = Mathf.RoundToInt(minMaxCurve.Evaluate(1f));
		minMaxCurve = this.vel.radial;
		this.actualRadialVel = Mathf.RoundToInt(minMaxCurve.Evaluate(1f));
	}
}