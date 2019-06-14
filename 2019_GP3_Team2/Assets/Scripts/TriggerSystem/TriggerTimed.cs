using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;

[AddComponentMenu("(つ♥v♥)つ/Triggers/Timed Trigger")]
public class TriggerTimed : MonoBehaviour
{
    public enum Mode { AfterDelay, DuringDuration }

    [Tooltip("After Delay: Next event will start [Duration Timer] time after delay \n\nDuring Duration: The event will happen during the [Duration Timer] timer, and stop when the time is done")]
    public Mode mode;

    [Tooltip("The time it takes for the next event to happen (depending on the Mode)")]
    public float durationTimer;


    public UnityEvent OnTrigger;


    public void Trigger()
    {
        if (mode == Mode.AfterDelay)
            StartCoroutine(StartTimer());
    }

    IEnumerator StartTimer()
    {
        yield return new WaitForSeconds(durationTimer);
        OnTrigger.Invoke();
    }

}
