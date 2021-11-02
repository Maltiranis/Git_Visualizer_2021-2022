using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AudioManager : MonoBehaviour
{

    public AudioSource source;

    private void Start()
    {

    }

    private void Update()
    {

    }

    public void ChangeAudioSource(AudioClip music)
    {
        if (source.clip.name == music.name)
            return;

        source.Stop();
        source.clip = music;
        source.Play();
    }
}