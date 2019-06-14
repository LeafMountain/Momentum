
using UnityEngine;

[RequireComponent(typeof(Rigidbody))]

public class Target : MonoBehaviour
{
    public float movementSpeed;

    
    [Tooltip("First create size of the path, then create empty objects and put them in the fields named element 0, element 1 etc.")]
    public Transform[] targetPoints;

    [Header("Min and max time paradox settings")]
    public float maxSpeed = 100f;
    public float minSpeed = 0f;

    private int current;
    private bool movingPlayer;

    Rigidbody requiredRigidBody;

    void Start()
    {
        requiredRigidBody = GetComponent<Rigidbody>();
        requiredRigidBody.useGravity = false;
        requiredRigidBody.isKinematic = true;
    }

    public void SpeedDown (float speedAmount)
    {
        movementSpeed -= speedAmount;
        Debug.Log(movementSpeed);

        if (movementSpeed < minSpeed)
        {
            movementSpeed = 0f;
            //Paradox();
        }
    }

    public void SpeedUp (float speedAmount)
    {
        movementSpeed += speedAmount;
        Debug.Log(movementSpeed);

        if (movementSpeed >= maxSpeed)
        {
            Paradox();
        }
    }

    void Update()
    {

         if (transform.position != targetPoints[current].position) //Move until you reach the current object/waypoint
            {
                Vector3 pos = Vector3.MoveTowards(transform.position, targetPoints[current].position, movementSpeed * Time.deltaTime);
                GetComponent<Rigidbody>().MovePosition(pos);
            }

         else current = (current + 1) % targetPoints.Length; //Object waypoint reached, move to the next object

    }

    private void OnCollisionEnter(Collision col)
    {
        movementSpeed = 0f;
        Debug.Log("I'm a collider!");
    }


    void Paradox ()
    {
        Debug.Log("You created a time paradox!");
        //movementSpeed = 50f;
    }




}
