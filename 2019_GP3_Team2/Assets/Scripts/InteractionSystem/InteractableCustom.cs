using UnityEngine;
using UnityEngine.Events;

[DisallowMultipleComponent, AddComponentMenu("(つ♥v♥)つ/Interaction/Interactable Custom")]
public class InteractableCustom : MonoBehaviour, IInteractionResponse
{
    public UnityEvent onInteract;
    public UnityEvent onFocus;
    public UnityEvent onUnfocus;

    public void Focus()
    {
        onFocus.Invoke();
    }

    public void Interact(Interactor Interactor)
    {
        onInteract.Invoke();
    }

    public void Unfocus()
    {
        onUnfocus.Invoke();
    }
}
