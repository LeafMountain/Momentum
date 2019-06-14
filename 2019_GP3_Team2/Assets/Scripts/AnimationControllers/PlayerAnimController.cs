using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerAnimController : MonoBehaviour
{
    Animator anim;
    bool isFiring1;
    bool isFiring2;
    float Speed;



    [SerializeField] private InputProfile _inputProfile;

    void Start()
    {
        anim = gameObject.GetComponent<Animator>();
        isFiring1 = false;
        isFiring2 = false;
    }


    void Update()
    {

        float move = Input.GetAxis("Vertical");
        anim.SetFloat("Speed", move);

        // float moveHorizontal = Input.GetAxis("Horizontal");
        // anim.SetFloat("Speed", moveHorizontal);

        if (_inputProfile.GetPrimaryFireButton())
        {
            isFiring1 = true;
        }
        else
        {
            isFiring1 = false;
        }

        if (isFiring1 == false)
        {
            anim.SetBool("isFiring001", false);
        }

        if (isFiring1 == true)
        {
            anim.SetBool("isFiring001", true);
        }


        if (_inputProfile.GetSecondaryFireButton())
        {
            isFiring2 = true;
        }
        else
        {
            isFiring2 = false;
        }

        if (isFiring2 == false)
        {
            anim.SetBool("isFiring002", false);
        }

        if (isFiring2 == true)
        {
            anim.SetBool("isFiring002", true);
        }

    }
}

