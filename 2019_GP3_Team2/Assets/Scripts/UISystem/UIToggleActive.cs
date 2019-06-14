using UnityEngine;

public class UIToggleActive : MonoBehaviour
{
    public void Trigger()
    {
        gameObject.SetActive(!gameObject.activeInHierarchy);
    }
}
