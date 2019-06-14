using UnityEngine;

public class MouseManager : MonoBehaviour
{
    public void ToggleMouse()
    {
        Cursor.visible = !Cursor.visible;
        Cursor.lockState = Cursor.lockState == CursorLockMode.Locked ? CursorLockMode.None : CursorLockMode.Locked;
    }

    public void LockMouse(bool state)
    {
        Cursor.visible = !state;
        Cursor.lockState = state ? CursorLockMode.Locked : CursorLockMode.None;
    }
}
