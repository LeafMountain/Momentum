using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[RequireComponent(typeof(Rigidbody)), DisallowMultipleComponent, AddComponentMenu("(つ♥v♥)つ/Time Manipulation/Manipulate Physics Objects", 0)]
public class PhysicsTimeManipulation : MonoBehaviour
{
    private float _timeScale = 1.0f;
    private Rigidbody _rigidbody;

    void Start()
    {
        _rigidbody = GetComponent<Rigidbody>();
        _rigidbody.useGravity = false;
    }

    void FixedUpdate()
    {
        float dt = Time.fixedDeltaTime * _timeScale;
        _rigidbody.velocity += Physics.gravity / _rigidbody.mass * dt;
    }

    public void SetTimeScale(float value)
    {
        value = Mathf.Clamp(value, 0.00001f, Mathf.Infinity);
        float tempTimeScaleApplied = value / _timeScale;
        _timeScale = value;

        _rigidbody.mass /= tempTimeScaleApplied;
        _rigidbody.velocity *= tempTimeScaleApplied;
        _rigidbody.angularVelocity *= tempTimeScaleApplied;
    }

    public void ResetTimeScale()
    {
        SetTimeScale(1);
    }
}
