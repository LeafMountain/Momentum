using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Killbox : MonoBehaviour
{
    //public GameObject secretBox;

    private void OnCollisionEnter(Collision col)
    {
       
            Destroy(col.gameObject);
    }

}
