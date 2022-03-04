using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ParticleOnClic : MonoBehaviour
{
    public ParticleSystem[] particlesToPlay;

    void Update()
    {
        OnClicEmit();
    }

    private void OnClicEmit ()
    {
        if (Input.GetMouseButtonDown(0))
        {
            foreach (ParticleSystem ptp in particlesToPlay)
            {
                ptp.Play(true);
            }
        }
        else
        {
            foreach (ParticleSystem ptp in particlesToPlay)
            {
                ptp.Stop(true);
            }
        }
    }
}
