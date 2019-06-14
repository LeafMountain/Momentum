using UnityEngine;

public interface IInteractionResponse
{
    void Interact(Interactor Interactor);
    void Focus();
    void Unfocus();
}
