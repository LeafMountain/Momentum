using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;

[AddComponentMenu("(つ♥v♥)つ/Events/Event Listener")]
public class Listener : MonoBehaviour
{
    [SerializeField] private ScriptableEvent _event;

    public UnityEvent OnEvent;

    private void OnEnable()
    {
        if (_event) _event.myEvent += TriggerUnityEvent;
    }

    private void OnDisable()
    {
        if (_event) _event.myEvent -= TriggerUnityEvent;
    }

    void TriggerUnityEvent()
    {
        OnEvent.Invoke();
    }
}
