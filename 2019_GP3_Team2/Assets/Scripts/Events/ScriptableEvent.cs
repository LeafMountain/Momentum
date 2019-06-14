using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[CreateAssetMenu(menuName = "EventHandling/ScriptableEvent")]
public class ScriptableEvent : ScriptableObject
{
    public delegate void Event();
    public Event myEvent;

    [ContextMenu("Execute")]
    public void Execute()
    {
        myEvent?.Invoke();
    }

}
