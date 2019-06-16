using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class RigibodyHasGravity : MonoBehaviour
{
    Rigidbody myRigidbody;
    
    void Start()
    {
        myRigidbody = GetComponent<Rigidbody>();
    }


    void Update()
    {
        if (Input.GetKeyDown(KeyCode.G))
        {
            GiveObjectGravity();
        }
    }

    public void GiveObjectGravity ()
    {
        myRigidbody.useGravity = true;
        myRigidbody.isKinematic = false;
    }

    public void MakeObjectKinematic ()
    {
        myRigidbody.useGravity = false;
        myRigidbody.isKinematic = true;
    }
}
