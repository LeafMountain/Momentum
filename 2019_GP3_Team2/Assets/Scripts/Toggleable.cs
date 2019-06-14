using UnityEngine;

public class Toggleable : MonoBehaviour
{
    public UnityEventBool OnToggle;

    bool currentState = false;

    public void Toggle()
    {
        currentState = !currentState;
        OnToggle.Invoke(currentState);
    }

    public void Toggle(int value)
    {
        currentState = value > 0 ? true : false;
        OnToggle.Invoke(currentState);
    }

    public void Toggle(float value)
    {
        Toggle(Mathf.FloorToInt(value));
    }
}
