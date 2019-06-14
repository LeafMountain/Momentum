using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AddSomeForceCollider : MonoBehaviour
{
    public float forceApplied = 50f;

    private void OnCollisionEnter(Collision collision)
    {
        if (collision.gameObject.tag == "player")
        {
            Debug.Log("Hit player!");
            collision.gameObject.GetComponent<Rigidbody>().AddForce(0, 0, forceApplied);
            
        }
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
