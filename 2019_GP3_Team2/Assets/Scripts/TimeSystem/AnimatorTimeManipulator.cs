using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[RequireComponent(typeof(Animator))]
[DisallowMultipleComponent, AddComponentMenu("(つ♥v♥)つ/Time Manipulation/Manipulate Animator")]
public class AnimatorTimeManipulator : MonoBehaviour
{
    Animator _anim;

    void Awake() => _anim = GetComponent<Animator>();

    public void SetTimeScale(float value)
    {
        _anim.speed = value;
    }

    public void ResetTimeScale()
    {
        _anim.speed = 1;
    }
}
