using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[RequireComponent(typeof(Animator))]
public class AnimationBool : MonoBehaviour
{
    public string propertyName;

    Animator animator;

    void Start()
    {
        animator = GetComponent<Animator>();
    }

    public void SetBool(bool value) => animator.SetBool(propertyName, value);
}
