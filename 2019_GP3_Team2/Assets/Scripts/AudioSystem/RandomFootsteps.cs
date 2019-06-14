using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class RandomFootsteps : MonoBehaviour

    
{

    CharacterController _cc;
    [SerializeField] AudioSource _footStep;
    
    void Start()
    {
        _cc = GetComponent<CharacterController>();
        //_footStep = GetComponent<AudioSource>();
    }

    
    void Update()
    {
        //&& timetest > 0.5
        //_footStep.isPlaying == false
        //float timetest = Time.time;

        bool isGrounded = GetComponent<MovementComponent>().IsGrounded();
        if (isGrounded == true && _cc.velocity.magnitude > 2f && _footStep.isPlaying == false && _footStep)
        {
            _footStep.volume = Random.Range(0.35f, 0.45f);
            _footStep.pitch = Random.Range(0.52f, 0.6f);
            _footStep.Play();
            //timetest = 0f;
        }


    }
}
