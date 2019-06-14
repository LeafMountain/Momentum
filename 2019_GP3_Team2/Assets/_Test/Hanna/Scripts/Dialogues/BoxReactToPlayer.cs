using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BoxReactToPlayer : MonoBehaviour
{
    //public GameObject[] spawnerArray;
    //public GameObject oneSpawner;
    public GameObject boxSpawnerPLAYER;
    public GameObject exclamationObject;
    public int _amountOfSpawns = 100;

    private bool _bigExclamation = false;
    public string companionMessage = " Oh Yeah, GET ALL THEM BOXES!!";



    private void OnCollisionEnter(Collision col)
    {
        if (col.gameObject.name == "player_temp")
        {
            if (_bigExclamation == false)
            {
                SendString exclamationYEAH = exclamationObject.GetComponent<SendString>();
                exclamationYEAH.SendCompanionMessage(companionMessage);
                _bigExclamation = true;
            }

            for (int i = 0; i < _amountOfSpawns; i++)
            {

                Spawner spawnOnPlace = boxSpawnerPLAYER.GetComponent<Spawner>();
                spawnOnPlace.SpawnSecretBoxes();
                Debug.Log("Should be spawning");

            }
            /*
            Debug.Log("SPAWN LOTS");
            foreach (GameObject spawner in spawnerArray)
            {
                Spawner boxSpawner = oneSpawner.GetComponent<Spawner>();
                boxSpawner.SpawnSecretBoxes();
            }
            */
        }
    }

    void Start()
    {
        boxSpawnerPLAYER = GameObject.Find("Spawners2/BoxSpawnerPLAYER");
        exclamationObject = GameObject.Find("Messages/ExclamationObject");
    }

    // Update is called once per frame
    void Update()
    {
        
    }
}
