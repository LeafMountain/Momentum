using System.Collections;
using System.Collections.Generic;
using UnityEngine;


[RequireComponent(typeof(CharacterController))]
public class Crouch : MonoBehaviour
{

    CharacterController _controller;

    bool crouching;


    // Start is called before the first frame update
    void Start()
    {
        _controller = GetComponent<CharacterController>();

        crouching = false;
    }

    // Update is called once per frame
    void Update()
    {
        if(Input.GetKey(KeyCode.LeftControl))
        {   
            crouching = true; 
            Debug.Log("LeftControl was pressed");

            _controller.height = 1.0f;
            
            //change speed
            //lerp vector position
            
        }

         if(Input.GetKeyUp(KeyCode.LeftControl))
        {   
            crouching = false; 
            Debug.Log("LeftControl was released");

            _controller.height = 2.0f;
           
             //change speed
            //lerp vector position
        }
    }
}
