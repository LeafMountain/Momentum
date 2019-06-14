using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[CreateAssetMenu(menuName = "Input/Keyboard Mouse")]
public class InputProfileKeyboardMouse : InputProfile
{
    [SerializeField] KeyCode _forwardKey;
    [SerializeField] KeyCode _backKey;
    [SerializeField] KeyCode _rightKey;
    [SerializeField] KeyCode _leftKey;

    [SerializeField] KeyCode _jumpKey;
    [SerializeField] KeyCode _primaryFireKey;
    [SerializeField] KeyCode _secondaryFireKey;
    [SerializeField] KeyCode _interactKey;

    [SerializeField] KeyCode _pauseButton;

    public override Vector2 GetInputVector()
    {
        float v = Input.GetKey(_forwardKey) ? 1 : 0;
        v += Input.GetKey(_backKey) ? -1 : 0;

        float h = Input.GetKey(_rightKey) ? 1 : 0;
        h += Input.GetKey(_leftKey) ? -1 : 0;

        return new Vector2(h, v);
    }

    public override bool GetJumpButton() => Input.GetKey(_jumpKey);
    public override bool GetPrimaryFireButton() => Input.GetKey(_primaryFireKey);
    public override bool GetSecondaryFireButton() => Input.GetKey(_secondaryFireKey);
    public override bool GetInteractButton() => Input.GetKey(_interactKey);

    public override bool GetJumpButtonDown() => Input.GetKeyDown(_jumpKey);
    public override bool GetPrimaryFireButtonDown() => Input.GetKeyDown(_primaryFireKey);
    public override bool GetSecondaryFireButtonDown() => Input.GetKeyDown(_secondaryFireKey);
    public override bool GetInteractButtonDown() => Input.GetKeyDown(_interactKey);

    public override bool GetJumpButtonUp() => Input.GetKeyUp(_jumpKey);
    public override bool GetPrimaryFireButtonUp() => Input.GetKeyUp(_primaryFireKey);
    public override bool GetSecondaryFireButtonUp() => Input.GetKeyUp(_secondaryFireKey);
    public override bool GetInteractButtonUp() => Input.GetKeyUp(_interactKey);

    public override bool GetPauseButton() => Input.GetKeyDown(_pauseButton);

    public override Vector2 GetLookVector() => new Vector2(Input.GetAxisRaw("Mouse X"), Input.GetAxisRaw("Mouse Y"));
}
