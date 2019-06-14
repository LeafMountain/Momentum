using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class RayWiever : MonoBehaviour
{

    public float shootRange = 50;

    private Camera fpsCam;

    void Start()
    {
        fpsCam = GetComponent<Camera>();
    }


    void Update()
    {
        Vector3 lineOrigin = fpsCam.ViewportToWorldPoint(new Vector3(0.5f, 0.5f, 0.0f));

        Debug.DrawRay(lineOrigin, fpsCam.transform.forward * shootRange, Color.green);
    }

}
