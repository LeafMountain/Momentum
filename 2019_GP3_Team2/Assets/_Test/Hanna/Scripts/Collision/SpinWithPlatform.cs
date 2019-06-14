using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SpinWithPlatform : MonoBehaviour

    

{
    public GameObject playerCollidePlatform;


    private void OnTriggerEnter(Collider other)
    {
        

        if(other.gameObject.tag == "Player")
        {
            Debug.Log("Caught player!");
            other.gameObject.transform.parent = transform;

        }
    }

  
    private void OnTriggerExit(Collider other)
    {
        if (other.gameObject.tag == "Player")
        {
            other.gameObject.transform.parent = null;
        }

        
    }



}
