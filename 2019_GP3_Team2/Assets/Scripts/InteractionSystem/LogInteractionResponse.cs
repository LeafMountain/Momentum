using UnityEngine;

public class LogInteractionResponse : MonoBehaviour, IInteractionResponse
{
    public void Focus()
    {
        Debug.Log("Focus");
    }

    public void Interact(Interactor interactor)
    {
        Debug.Log("Interact");
    }

    public void Unfocus()
    {
        Debug.Log("Unfocus");
    }
}
