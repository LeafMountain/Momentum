using System;
using UnityEngine;


public class RaycastGun : MonoBehaviour
{

    public float speedDown = 5f;
    public float speedUp = 5f;

    public float rotateSpeedDown = 0.5f;
    public float rotateSpeedUp = 0.5f;

    public float gunRange = 100f;

    public Camera fpsCam;



   


    void Update()
    {
        if (Input.GetButtonDown("Fire1"))
        {
            Shoot();
        }

        if (Input.GetButtonDown("Fire2"))
        {
            ShootTwo();
        }
    }

    void Shoot()
    {
        RaycastHit hit;
        if (Physics.Raycast(fpsCam.transform.position, fpsCam.transform.forward, out hit, gunRange))
        {
            Debug.Log(hit.transform.name);

            Target targetHit = hit.transform.GetComponent<Target>();
            if (targetHit != null)
            {
                targetHit.SpeedDown(speedDown);

            }

            TargetRotator targetHitRotator = hit.transform.GetComponent<TargetRotator>();
            if (targetHitRotator != null)
            {
                targetHitRotator.SpeedDown(rotateSpeedDown);

            }

            Sender senderHit = hit.transform.GetComponent<Sender>();
            if (senderHit != null)
            {
                senderHit.SpeedDown(speedDown);
            }
            /*
            GameobjectArray senderHitArray = hit.transform.GetComponent<GameobjectArray>();
            if (senderHitArray != null)
            {
                senderHitArray.SpeedDown(speedDown);
            }
            */
        }

    }

    void ShootTwo()
    {
        RaycastHit hit;
        if (Physics.Raycast(fpsCam.transform.position, fpsCam.transform.forward, out hit, gunRange))
        {
            Debug.Log(hit.transform.name);

            Target targetHit = hit.transform.GetComponent<Target>();
            if (targetHit != null)
            {
                targetHit.SpeedUp(speedUp);

            }

            TargetRotator targetHitRotator = hit.transform.GetComponent<TargetRotator>();
            if (targetHitRotator != null)
            {
                targetHitRotator.SpeedUp(rotateSpeedUp);
            }

            Sender senderHit = hit.transform.GetComponent<Sender>();
            if (senderHit != null)
            {
                senderHit.SpeedUp(speedUp);
            }
        }
    }
}
