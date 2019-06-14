using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[RequireComponent(typeof(Rigidbody))]
public class TargetRotator : MonoBehaviour
{

    public float movementSpeed;

    [Header("Select ONLY ONE axis it should rotate on.")]
    public bool xAxis;
    public bool yAxis;
    public bool zAxis;

    [Header("Min and max time paradox settings")]
    public float maxSpeed = 10f;
    public float minSpeed = 0f;

    Rigidbody requiredRigidBody;

    public void SpeedDown(float speedAmount)
    {
        movementSpeed -= speedAmount;
        Debug.Log(movementSpeed);

        if (movementSpeed < minSpeed)
        {
            movementSpeed = 0f;
            //ParadoxRotate();
        }
    }

    public void SpeedUp(float speedAmount)
    {
        movementSpeed += speedAmount;
        Debug.Log(movementSpeed);

        if (movementSpeed >= maxSpeed)
        {
            ParadoxRotate();
        }
    }

    private void Start()
    {
        requiredRigidBody = GetComponent<Rigidbody>();
        requiredRigidBody.useGravity = false;
        requiredRigidBody.isKinematic = true;
    }

    void Update()
    {
        if (xAxis == true)
        {
            transform.Rotate(movementSpeed, 0, 0);
        }

        else if (yAxis == true)
        {
            transform.Rotate(0, movementSpeed, 0);
        }

        else if (zAxis == true)
        {
            transform.Rotate(0, 0, movementSpeed);
        }
        
    }


    void ParadoxRotate()
    {
        Debug.Log("You created a time paradox!");
        //movementSpeed = 5f;
    }
}
