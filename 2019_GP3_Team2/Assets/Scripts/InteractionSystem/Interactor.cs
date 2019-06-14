using UnityEngine;

[DisallowMultipleComponent, AddComponentMenu("(つ♥v♥)つ/Interaction/Interactor")]
public class Interactor : MonoBehaviour
{
    public InputProfile input;
    public float range = 1;

    float _radius = .2f;
    GameObject _targetGameObject;
    IInteractionResponse _target;
    IInteractionResponse[] _targets;

    void Update()
    {
        // TODO: Focus and unfocus muliple components

        (IInteractionResponse, GameObject) interactable = GetLookTarget();

        if (_target != interactable.Item1)
        {
            if (_target != null)
            {
                _target.Unfocus();
                _target = null;
                _targetGameObject = null;
            }

            if (interactable.Item1 != null)
            {
                _target = interactable.Item1;
                _targetGameObject = interactable.Item2;
                _target.Focus();
            }
        }

        if (input && input.GetInteractButton())
            Interact();
    }

    public void Interact()
    {
        // Interact with interactable
        if (_target != null)
        {
            foreach (var interactable in _targetGameObject.GetComponents<IInteractionResponse>())
                interactable.Interact(this);
        }
    }

    public (IInteractionResponse, GameObject) GetLookTarget()
    {
        IInteractionResponse interactable = null;
        GameObject interactableGO = null;

        Ray lookRay = new Ray(transform.position, transform.forward);
        RaycastHit hit;

        if (Physics.SphereCast(transform.position, _radius, transform.forward, out hit, range))
        {
            interactable = hit.transform.GetComponent<IInteractionResponse>();
            interactableGO = hit.transform.gameObject;
        }

        return (interactable, interactableGO);
    }

    void FocusTargets(IInteractionResponse interactables)
    {
        for (int i = 0; i < _targets.Length; i++)
            if (_targets[i] != null)
                _targets[i].Focus();
    }

    void UnfocusTargets()
    {
        for (int i = 0; i < _targets.Length; i++)
            if (_targets[i] != null)
            {
                _targets[i].Unfocus();
                _targets[i] = null;
            }
    }

    void InteractWithTargets()
    {
        for (int i = 0; i < _targets.Length; i++)
            if (_targets[i] != null)
            {
                _targets[i].Interact(this);
            }
    }

#if UNITY_EDITOR
    void OnDrawGizmos()
    {
        Gizmos.color = Color.red;
        Gizmos.DrawRay(transform.position, transform.forward);
    }
#endif
}
