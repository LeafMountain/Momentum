using System;
using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;
using UnityEngine.Events;

public class PrintAIText : MonoBehaviour
{
    [Header("Delays")]
    [Tooltip("Delay between new letter")]
    [SerializeField] private float _delay = 0.03f;
    [Tooltip("Delay after dot")]
    [SerializeField] private float _dotDelay = 0.6f;
    [Tooltip("Delay after comma")]
    [SerializeField] private float _commaDelay = 0.3f;
    [Tooltip("Delay after all text is done")]
    [SerializeField] private float _doneDelay = 0.4f;
    [Tooltip("Delay before starting text (so the animation can be done)")]
    [SerializeField] private float _startDelay = 0.4f;

    [Header("Events"), Space(10)]
    [SerializeField] private UnityEvent _onPrintMessage;
    [SerializeField] private UnityEvent _onFinishedTypingMessage;

    private TMP_Text _textMesh;

    private bool _isTyping = false;
    private Queue<string> _triggeredResponseQueue = new Queue<string>();

    private void Start()
    {
        _textMesh = GetComponent<TMP_Text>();
        if (!_textMesh)
        {
            Debug.LogError("There is no " + _textMesh + " in " + this);
            return;
        }
    }


    private IEnumerator ShowText()
    {
        string text = _triggeredResponseQueue.Dequeue();
   
            _isTyping = true;
        yield return new WaitForSeconds(_startDelay);
        for (int i = 0; i < text.Length; i++)
        {
            _textMesh.text = text.Substring(0, i + 1);

            switch (text.ToCharArray()[i])
            {
                case '.':
                    yield return new WaitForSeconds(_dotDelay);
                    break;

                case ',':
                    yield return new WaitForSeconds(_commaDelay);
                    break;

                case '!':
                    yield return new WaitForSeconds(_commaDelay);
                    break;

                case '?':
                    yield return new WaitForSeconds(_dotDelay);
                    break;

                default:
                        yield return new WaitForSeconds(_delay);
                    break;
            }
        }
        yield return new WaitForSeconds(_doneDelay);
        if (_triggeredResponseQueue.Count > 0)
            StartCoroutine(ShowText());
        
        else
        {
            _isTyping = false;
            _onFinishedTypingMessage.Invoke();
        }
    }

    public void WriteResponse(string respons)
    {
        _triggeredResponseQueue.Enqueue(respons);

        if (_isTyping) return;

        _onPrintMessage.Invoke();
        _textMesh.text = "";
        StartCoroutine(ShowText());
    }
}
