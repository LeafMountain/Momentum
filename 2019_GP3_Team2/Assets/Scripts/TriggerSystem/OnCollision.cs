using UnityEngine;
using UnityEngine.Events;

public class OnCollision : MonoBehaviour
{
    public UnityEvent<Vector3> OnEnter;
    public float force = 500;

    void OnCollisionEnter(Collision col)
    {
        GetComponent<Rigidbody>()?.AddForce(Vector3.up * force);

    }
}

