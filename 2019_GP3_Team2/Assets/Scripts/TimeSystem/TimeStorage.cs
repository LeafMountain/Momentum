using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Serialization;
using UnityEngine.Events;

[DisallowMultipleComponent, AddComponentMenu("(つ♥v♥)つ/Time Manipulation/Time Storage")]
public class TimeStorage : MonoBehaviour, IShootTarget
{

    public bool onOnStart = false;
    [FormerlySerializedAs("slowStateMultiplier")]
    public float offMultiplier = 0;
    [FormerlySerializedAs("normalStateMultiplier")]
    public float onMultiplier = 1;

    public UnityEventFloat OnNewTimeScale;
    public UnityEvent onActivated;
    public UnityEvent onDeactivated;


    void Start()
    {
        SetDefaultState();
        // UpdateEvents();
    }

    // public int InsertTime(int value)
    // {
    //     charges += value;
    //     OnNewTimeScale.Invoke(fastStateMultiplier);
    //     return 0;
    // }

    // public int ExtractTime(int value)
    // {
    //     charges += value;
    //     OnNewTimeScale.Invoke(slowStateMultiplier);
    //     return 0;
    // }

    public void SetOffState()
    {
        OnNewTimeScale.Invoke(offMultiplier);
        onDeactivated.Invoke();
    }

    public void SetOnState()
    {
        OnNewTimeScale.Invoke(onMultiplier);
        onActivated.Invoke();
    }

    public void SetDefaultState()
    {
        if (onOnStart)
            SetOnState();
        else
            SetOffState();

        float multiplier = onOnStart ? onMultiplier : offMultiplier;
        OnNewTimeScale?.Invoke(multiplier);
    }

    // public void SetFastState()
    // {
    //     OnNewTimeScale.Invoke(fastStateMultiplier);
    // }

    // void UpdateEvents()
    // {
    //     OnNewTimeScale.Invoke(charges);
    // }

    public void OnShot(ShootComponent instagator, float damage) { }
}
