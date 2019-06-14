using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[CreateAssetMenu(menuName = "Input/Continous")]
public class InputProfileContinous : InputProfile
{
    public override Vector2 GetInputVector() => Vector2.zero;
    public override Vector2 GetLookVector() => Vector2.zero;

    public override bool GetJumpButton() => true;
    public override bool GetPrimaryFireButton() => true;
    public override bool GetSecondaryFireButton() => true;
    public override bool GetInteractButton() => true;

    public override bool GetJumpButtonDown() => true;
    public override bool GetPrimaryFireButtonDown() => true;
    public override bool GetSecondaryFireButtonDown() => true;
    public override bool GetInteractButtonDown() => true;

    public override bool GetJumpButtonUp() => true;
    public override bool GetPrimaryFireButtonUp() => true;
    public override bool GetSecondaryFireButtonUp() => true;
    public override bool GetInteractButtonUp() => true;
}
