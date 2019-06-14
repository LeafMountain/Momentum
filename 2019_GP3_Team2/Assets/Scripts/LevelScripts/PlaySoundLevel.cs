using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlaySoundLevel : MonoBehaviour
{
    public AudioClip audioClip;

    public AudioSource audioSource;
    
    void Start()
    {
        audioSource.clip = audioClip;
    }

    
    void Update()
    {
        if (Input.GetKeyDown(KeyCode.F))
        {
            audioSource.Play();
        }
    }
}
