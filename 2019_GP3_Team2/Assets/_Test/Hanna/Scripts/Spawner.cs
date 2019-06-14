using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Spawner : MonoBehaviour
{
    public GameObject spawnerObject;
    public GameObject spawnedObject;
    



    // Update is called once per frame
    void Update()
    {
        if (Input.GetKeyDown("left ctrl"))
        {
            
            SpawnSecretBoxes();
            /*
            GameObject tempObjectHandler;
            tempObjectHandler = Instantiate(spawnerObject, spawnedObject.transform.position, spawnerObject.transform.rotation) as GameObject;

            Rigidbody tempRigidbody;
            tempRigidbody = tempObjectHandler.GetComponent<Rigidbody>();
            */

            //Destroy(tempObjectHandler, 10f);
        }
    }

    public void SpawnSecretBoxes ()
    {
        



            Debug.Log("Spawn box");
            GameObject tempObjectHandler;
            tempObjectHandler = Instantiate(spawnerObject, spawnedObject.transform.position, spawnerObject.transform.rotation) as GameObject;

            Rigidbody tempRigidbody;
            tempRigidbody = tempObjectHandler.GetComponent<Rigidbody>();

    }
}
