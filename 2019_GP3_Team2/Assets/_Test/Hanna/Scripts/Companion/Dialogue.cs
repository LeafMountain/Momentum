using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;

public class Dialogue : MonoBehaviour
{
    public TextMeshProUGUI textDisplay;
    public string[] companionPhrases;
    public float typingSpeed;

    private int _phraseIndex;

    private void Start()
    {
        StartCoroutine(Type());
    }

    IEnumerator Type()
    {
        foreach (char letter in companionPhrases[_phraseIndex].ToCharArray())
        {
            yield return new WaitForSeconds(typingSpeed);
            
        }
        
    }


}
