﻿using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SpawnP : MonoBehaviour {

    public GameObject firePoint;
    public List<GameObject> vfx = new List<GameObject> ();

    private GameObject effectToSpawn;   

    void Start () {
        effectToSpawn = vfx [0];

    }


    void Update () {
        if(Input.GetMouseButton(0)) {
            spawnVFX();
        }

    }

    void spawnVFX() {
        GameObject vfx;

        if (firePoint != null) {
            vfx = Instantiate(effectToSpawn, firePoint.transform.position, Quaternion.identity);

        } else {
            Debug.Log("No Fire Point");

        }
    }

}