using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class InputProfile : ScriptableObject
{
    public virtual Vector2 GetInputVector() => Vector2.zero;
    public virtual Vector2 GetLookVector() => Vector2.zero;

    public virtual bool GetJumpButton() => false;
    public virtual bool GetPrimaryFireButton() => false;
    public virtual bool GetSecondaryFireButton() => false;
    public virtual bool GetInteractButton() => false;

    public virtual bool GetJumpButtonDown() => false;
    public virtual bool GetPrimaryFireButtonDown() => false;
    public virtual bool GetSecondaryFireButtonDown() => false;
    public virtual bool GetInteractButtonDown() => false;

    public virtual bool GetJumpButtonUp() => false;
    public virtual bool GetPrimaryFireButtonUp() => false;
    public virtual bool GetSecondaryFireButtonUp() => false;
    public virtual bool GetInteractButtonUp() => false;

    public virtual bool GetPauseButton() => false;
}
