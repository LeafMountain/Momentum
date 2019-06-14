using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class OldCharacterController : MonoBehaviour
{
    public float playerSpeed = 10f;
    
    void Start()
    {
        //Cursor.lockState = CursorLockMode.Locked;
    }

    
    void Update()
    {
        float translation = Input.GetAxis("Vertical") * playerSpeed;
        float straffe = Input.GetAxis("Horizontal") * playerSpeed; //Strafing since it's FPS
        translation *= Time.deltaTime;
        straffe *= Time.deltaTime;

        transform.Translate(straffe, 0, translation);

        /* if (Input.GetKeyDown("escape"))
            Cursor.lockState = CursorLockMode.None;
            */
    }
}
