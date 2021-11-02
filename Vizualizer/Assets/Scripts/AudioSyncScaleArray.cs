using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AudioSyncScaleArray : MonoBehaviour {

	public GameObject[] arrayItem;
	float[] biasArray;

	public float bias;
	public float timeStep;
	public float timeToBeat;
	public float restSmoothTime;

	private float m_previousAudioValue;
	private float m_audioValue;
	private float m_timer;

	bool m_isBeat;

	private void Start() 
	{
		for	(int i = 0; i < arrayItem.Length; i++)
		{
			biasArray[i] = (i + 1) * (bias / arrayItem.Length);
		}
	}

	void OnBeat()
	{
		Debug.Log("beat");
		m_timer = 0;
		m_isBeat = true;

		StopCoroutine("MoveToScale");
		StartCoroutine("MoveToScale", beatScale);
	}

	void Update()
	{
		// update audio value
		m_previousAudioValue = m_audioValue;
		m_audioValue = AudioSpectrum.spectrumValue;

		// if audio value went below the bias during this frame
		for	(int i = 0; i < arrayItem.Length; i++)
		{
			if (m_previousAudioValue > biasArray[i] && m_audioValue <= biasArray[i])
			{
				// if minimum beat interval is reached
				if (m_timer > timeStep)
					OnBeat();
			}

			// if audio value went above the bias during this frame
			if (m_previousAudioValue <= biasArray[i] && m_audioValue > biasArray[i])
			{
				// if minimum beat interval is reached
				if (m_timer > timeStep)
					OnBeat();
			}
		}

		m_timer += Time.deltaTime;

		if (m_isBeat) return;
		for	(int i = 0; i < arrayItem.Length; i++)
		{
			arrayItem[i].transform.localScale = Vector3.Lerp(arrayItem[i].transform.localScale, restScale, restSmoothTime * Time.deltaTime);
		}
	}

	private IEnumerator MoveToScale(Vector3 _target)
	{
		for	(int i = 0; i < arrayItem.Length; i++)
		{
			Vector3 _curr = arrayItem[i].transform.localScale;
			Vector3 _initial = _curr;
			float _timer = 0;

			while (_curr != _target)
			{
				_curr = Vector3.Lerp(_initial, _target, _timer / timeToBeat);
				_timer += Time.deltaTime;

				arrayItem[i].transform.localScale = _curr;

				yield return null;
			}
		}

		m_isBeat = false;
	}

	public Vector3 beatScale;
	public Vector3 restScale;
}
