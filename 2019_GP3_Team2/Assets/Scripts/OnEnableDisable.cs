using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;

public class OnEnableDisable : MonoBehaviour
{
    public UnityEvent OnEnableEvent;
    public UnityEvent OnDisableEvent;

    public void OnEnable() => OnEnableEvent?.Invoke();
    public void OnDisable() => OnDisableEvent?.Invoke();

}
