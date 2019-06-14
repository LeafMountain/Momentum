using UnityEngine;

[CreateAssetMenu(menuName = "Variables/bool")]
public class BoolVariable : ScriptableObject
{
    public bool value;
    public void SetValue(bool value) => this.value = value;

    
}
