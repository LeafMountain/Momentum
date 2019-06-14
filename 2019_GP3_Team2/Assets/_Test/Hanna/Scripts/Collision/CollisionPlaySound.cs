using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CollisionPlaySound : MonoBehaviour
{
    public AudioSource collisionAudioSource;

    private void OnCollisionEnter(Collision collision)
    {
        collisionAudioSource.Play();
    }

}
