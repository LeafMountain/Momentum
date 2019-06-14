using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;

[DisallowMultipleComponent, AddComponentMenu("(つ♥v♥)つ/Timers/Timer Component")]
public class TimerComponent : MonoBehaviour
{
    [System.Serializable]
    public struct EventTimer
    {
        [Tooltip("Time (in seconds) until event is fired after TimerStart")]
        public float timeUntilEvent;
        public UnityEvent timeEvent;

        [HideInInspector]
        public bool fired;
    }

    [SerializeField]
    EventTimer[] _eventTimers;

    float _elapsedTime = 0.0f;
    bool _timerEnabled = false;

    void Update()
    {
        if (_timerEnabled)
        {
            _elapsedTime += Time.deltaTime;

            for (int i = 0; i < _eventTimers.Length; i++)
            {
                if (_eventTimers[i].fired)
                    continue;

                if (_elapsedTime >= _eventTimers[i].timeUntilEvent)
                {
                    _eventTimers[i].fired = true;
                    _eventTimers[i].timeEvent.Invoke();
                }
            }
        }
    }

    public void StartTimer() => _timerEnabled = true;

    public void EndTimer()
    {
        _timerEnabled = false;
        _elapsedTime = 0.0f;
    }

    public void ResetTimer() => _elapsedTime = 0.0f;

    public void SetTimeElapsed(float time) => _elapsedTime = time;
    
    public void ResetEvents()
    {
        for (int i = 0; i < _eventTimers.Length; i++)
        {
            _eventTimers[i].fired = false;
        }
    }
}
