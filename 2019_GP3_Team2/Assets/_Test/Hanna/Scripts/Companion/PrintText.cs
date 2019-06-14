using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using TMPro;

public class PrintText : MonoBehaviour
{
    public TMP_Text m_TextComponent;
    public string[] sentencesCompanion;
    private int _index;
    private int _eventindex;

    private string _annoyingSpace = " ";

    public bool sentences;
    public bool events;

    public string[] eventOne;

    public float typingSpeed = 0.02f;
    //public gameobject continueButton; PREVENT SPAMCLICK

        public void WriteOutMessage (string companionMessage)
    {
        //Debug.Log("Got the message!");
        Debug.Log(companionMessage);
        m_TextComponent.text = "";
        StartCoroutine(TypeSentence(companionMessage));
        m_TextComponent.text = "";
    }


    IEnumerator TypeSentence(string sentence)
    {
        foreach (char letter in sentence.ToCharArray())
        {
            m_TextComponent.text += letter;
            yield return new WaitForSeconds(typingSpeed);
        }
    }



    public void NextSentence()
    {
        Debug.Log("Sentences wrote");
        //continueButton.SetActive(false); PREVENT SPAMCLICK CODE.

        if (_index < sentencesCompanion.Length - 1) //This code writes out the next sentence if there's any sentences left, it's not what we're going to use for the events.
        {
            _index++;
            m_TextComponent.text = "";
            StartCoroutine(TYPE()); //Starts the coroutine.
            m_TextComponent.text = ""; //Resets text when complete.
        }
    }

    public void StartBanter()
    {
        //continueButton.SetActive(false); PREVENT SPAMCLICK CODE.
        Debug.Log("P wrote");


        if (_eventindex < eventOne.Length - 1) //This code writes out the next sentence if there's any sentences left, it's not what we're going to use for the events.
        {
            _eventindex++;
            m_TextComponent.text = "";
            StartCoroutine(TYPE()); //Starts the coroutine.
            m_TextComponent.text = ""; //Resets text when complete.
        }
    }




    IEnumerator TYPE()
    {


       
        if (sentences == true)
        {
            foreach (char letter in sentencesCompanion[_index].ToCharArray())
            {
                m_TextComponent.text += letter;
                yield return new WaitForSeconds(typingSpeed);
            }
        }

        if (events == true)
        {
            foreach (char letter2 in eventOne[_eventindex].ToCharArray())
            {
                m_TextComponent.text += letter2;
                yield return new WaitForSeconds(typingSpeed);
            }
        }

        
    }



    void Awake()
    {
        m_TextComponent = GetComponent<TMP_Text>();
        //m_TextComponent.text = "BAJAJJAJAJAJJA!!!!!";
    }

    void Start()
    {
        //StartCoroutine(TypeSentence());
            //StartCoroutine(TYPE());
    }

    
    void Update()
    {


        /* USE THIS IF YOU WANT A VISUAL AID FOR WHEN IT'S DONE, ALSO PREVENT SPAMCLICK. THE CORRESPONDING CODE NEEDED IS NOW FOUND UNDER NextSentence()

        if (m_TextComponent.text == sentencesCompanion[_index])
        {
            continueButton.SetActive(true);
        }

        */

        if (Input.GetKeyDown(KeyCode.N))
        {
            sentences = true;
            events = false;
            NextSentence();
        }

        
        if (Input.GetKeyDown(KeyCode.P))
        {
            events = true;
            sentences = false;
            StartBanter();
        }

    }
}
