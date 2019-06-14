using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SendString : MonoBehaviour
{
    public string companionMessage;
    public GameObject textDisplay;
    public GameObject animatedDisplay;
    private GameObject _thisObject;
    private bool hasSentMessage;
    public float waitForText;

    private void Start()
    {
        //textDisplay.GetComponent<PrintText>();
        _thisObject = this.gameObject;
    }

    private void OnTriggerEnter(Collider other)
    {

        if (hasSentMessage == false)
        { 
            /*
            DisplayAnimations displayAnimation = animatedDisplay.GetComponent<DisplayAnimations>();
            displayAnimation.GoUp();

            */
            SendCompanionMessage(companionMessage);
            hasSentMessage = true;
            
        }

    }
    
    /*
    private void OnCollisionEnter(Collision collision)
    {
        if (hasSentMessage == false)
        {
            DisplayAnimations displayAnimation = animatedDisplay.GetComponent<DisplayAnimations>();
            displayAnimation.GoUp();

            SendCompanionMessage(companionMessage);
            //_thisObject.SetActive(false);
            hasSentMessage = true;
        }

    }
    */

    public void SendCompanionMessage (string companionMessage)
    {
        DisplayAnimations displayAnimation = animatedDisplay.GetComponent<DisplayAnimations>();
        displayAnimation.GoUp();

        PrintText messageReceiver = textDisplay.GetComponent<PrintText>();
        messageReceiver.WriteOutMessage(companionMessage);
        //Deactivate();
    }

    public void Deactivate ()
    {
        _thisObject.SetActive(false);
    }



}
