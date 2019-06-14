using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Sender : MonoBehaviour
{
    public GameObject[] receiverObjects;

    public float speedDown;
    public float speedUp;

    public float rotateSpeedDown;
    public float rotateSpeedUp;

    
       

    public void SpeedDown (float speedDown)
    {
        foreach (GameObject receiverObject in receiverObjects)
        {
            Debug.Log(receiverObject.name + "Received the signal to slow down!");
            Target targetHit = receiverObject.GetComponent<Target>();
            if (targetHit != null)
            {
                targetHit.SpeedDown(speedDown);
            }

            TargetRotator targetHitRotator = receiverObject.GetComponent<TargetRotator>();
            if (targetHitRotator != null)
            {
                targetHitRotator.SpeedDown(speedDown);
            }

            Sender senderHit = receiverObject.GetComponent<Sender>();
            if (senderHit != null)
            {
                senderHit.SpeedDown(speedDown);
            }
        }
    }

    public void SpeedUp (float speedUp)
    {
        foreach (GameObject receiverObject in receiverObjects)
        {
            Debug.Log(receiverObject.name + "Received the signal to speed up!");
            Target targetHit = receiverObject.GetComponent<Target>();
            if (targetHit != null)
            {
                targetHit.SpeedUp(speedUp);
            }

            TargetRotator targetHitRotator = receiverObject.GetComponent<TargetRotator>();
            if (targetHitRotator != null)
            {
                targetHitRotator.SpeedUp(speedUp);
            }

            Sender senderHit = receiverObject.GetComponent<Sender>();
            if (senderHit != null)
            {
                senderHit.SpeedUp(speedUp);
            }
        }
    }

    void Start()
    {
        foreach (GameObject receiverObject in receiverObjects)
        {
            Debug.Log(receiverObject.name + "reported in!");
        }
        
}

    // Update is called once per frame
    void Update()
    {
        
    }
}
