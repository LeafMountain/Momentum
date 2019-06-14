using UnityEngine;
using UnityEngine.Events;

public class RunOnStart : MonoBehaviour
{
    public UnityEvent OnAwake;
    public UnityEvent OnStart;

    void Awake() => OnAwake.Invoke();
    void Start() => OnStart.Invoke();
}
