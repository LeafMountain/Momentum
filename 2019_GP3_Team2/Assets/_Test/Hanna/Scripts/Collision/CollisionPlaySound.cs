using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CollisionPlaySound : MonoBehaviour
{
    public AudioSource collisionAudioSource;
    private bool _isSoundEnabled = true;

    private void OnCollisionEnter(Collision collision)
    {
        if (_isSoundEnabled == true)
        {
            collisionAudioSource.Play();
        }
    }

    public void DisableSound ()
    {
        _isSoundEnabled = false;
    }

    public void EnableSound ()
    {
        _isSoundEnabled = true;
    }

}
