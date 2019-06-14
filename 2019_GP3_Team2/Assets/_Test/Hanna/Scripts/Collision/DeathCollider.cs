using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DeathCollider : MonoBehaviour
{

    private void OnCollisionEnter(Collision collision)
    {
        Debug.Log("Colliding (name) : " + collision.collider.gameObject.name);
    }
    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        
    }
}
