using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DisplayFlip : MonoBehaviour
{

    public float flipAmount = 30;


    private void Awake()
    {

    }

    private void Start()
    {
        
    }

    private void Update()
    {
        if (Input.GetKey(KeyCode.A))
        {


            transform.localPosition = new Vector3(-0.5f, -1.0f, 1.2f * Time.deltaTime);
            transform.Rotate (Vector3.up * flipAmount * Time.deltaTime);
        }

        if (Input.GetKey(KeyCode.D))
        {
            transform.localPosition = new Vector3(0, 1, 0);
            //transform.Rotate(-Vector3.up * flipAmount * Time.deltaTime);
        }
    }
}
