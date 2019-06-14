using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[CreateAssetMenu(menuName = "Variables/float")]
public class FloatVariable : ScriptableObject
{
    public delegate void VariableEvent();
    public VariableEvent OnValueChanged;
    public float value;

    public void SetValue(float value)
    {
        this.value = value;
        OnValueChanged?.Invoke();
    }
}
