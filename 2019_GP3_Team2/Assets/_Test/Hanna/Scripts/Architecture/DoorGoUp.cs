using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DoorGoUp : MonoBehaviour
{
    private Animator _animatedDoorGoUp;
    private void Start()
    {
        _animatedDoorGoUp = GetComponent<Animator>();
    }

    public void DoorGoesUp()
    {
        _animatedDoorGoUp.SetBool("isDoorOpening", true);
    }


    private void Update()
    {
//         if (Input.GetKeyDown(KeyCode.P))
//         {
//             DoorGoesUp();
//         }
    }

}
