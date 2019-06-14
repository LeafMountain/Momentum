using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BoxInCorrectPlace : MonoBehaviour
{
    public GameObject superSecretBox;
    public string companionMessage;
    public GameObject textDisplay;
    public GameObject animatedDisplay;

    private GameObject _thisObject;
    private bool hasSentMessage;
    public float waitForText;

    void Start()
    {
        _thisObject = this.gameObject;
    }

    
    void Update()
    {
        
    }

    private void OnTriggerEnter(Collider col)
    {
        if (col.CompareTag("SecretBox"))
        {
            Debug.Log("Correct box");
            if (hasSentMessage == false)
            {
                Debug.Log("Should send message to screen.");

                DisplayAnimations displayAnimation = animatedDisplay.GetComponent<DisplayAnimations>();
                displayAnimation.GoUp();

                SendCompanionMessage(companionMessage);
                hasSentMessage = true;
            }
        }
    }


    public void SendCompanionMessage(string companionMessage)
    {
        PrintText messageReceiver = textDisplay.GetComponent<PrintText>();
        messageReceiver.WriteOutMessage(companionMessage);
        
    }
}
