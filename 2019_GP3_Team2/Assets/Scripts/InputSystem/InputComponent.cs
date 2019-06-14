using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;

public class InputComponent : MonoBehaviour
{
    public InputProfile inputProfile;

    public UnityEvent OnJump;
    public UnityEvent OnInteract;

    [Header("Triggers")]
    public UnityEvent OnPrimaryFire;
    public UnityEvent OnPrimaryFireDown;
    public UnityEvent OnPrimaryFireUp;

    public UnityEvent OnSecondaryFire;
    public UnityEvent OnSecondaryFireUpDown;
    public UnityEvent OnSecondaryFireUp;

    [Header("Axis")]
    public UnityEventVector2 OnLookAxis;
    public UnityEventVector2 OnMoveAxis;

    [Header("Other")]
    public UnityEvent OnPauseButton;

    void Update()
    {
        if (inputProfile.GetJumpButton()) OnJump.Invoke();
        if (inputProfile.GetPrimaryFireButton()) OnPrimaryFire.Invoke();
        if (inputProfile.GetSecondaryFireButton()) OnSecondaryFire.Invoke();
        if (inputProfile.GetPauseButton()) OnPauseButton.Invoke();
    }
}
