using System.Collections.Generic;
using UnityEngine;

[RequireComponent(typeof(MeshRenderer))]
[DisallowMultipleComponent, AddComponentMenu("(つ♥v♥)つ/Interaction/Interactable Outline")]
public class InteractableOutline : MonoBehaviour, IInteractionResponse
{
    public Material outlineMaterial;

    MeshRenderer renderer;

    void Start()
    {
        renderer = GetComponent<MeshRenderer>();
    }

    public void Focus()
    {
        List<Material> materials = new List<Material>();
        materials.AddRange(renderer.materials);
        materials.Add(outlineMaterial);
        renderer.materials = materials.ToArray();
    }

    public void Interact(Interactor Interactor)
    {
    }

    public void Unfocus()
    {
        List<Material> materials = new List<Material>();
        materials.AddRange(renderer.materials);
        materials.RemoveAt(materials.Count - 1);
        renderer.materials = materials.ToArray();
    }
}
