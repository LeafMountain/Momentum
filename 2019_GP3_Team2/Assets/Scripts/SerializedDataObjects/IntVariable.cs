using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[CreateAssetMenu(menuName = "Variables/int")]
public class IntVariable : ScriptableObject
{
    public int value;

    public void SetValue(int value) => this.value = value;
}
