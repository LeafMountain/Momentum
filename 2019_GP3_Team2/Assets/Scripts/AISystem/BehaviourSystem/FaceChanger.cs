using UnityEngine;

public class FaceChanger : MonoBehaviour
{

    private SpriteRenderer _renderer;
    private AIBehaviourComponent _ai;

    private void Start()
    {
        _renderer = GetComponent<SpriteRenderer>();
        _ai = GetComponentInParent<AIBehaviourComponent>();

        if (!_ai)
        {
            Debug.LogError("There is no " + _ai + " in the parent of " + gameObject.name);
            return;
        }
    }

    public void UpdateFace() =>_renderer.sprite = _ai.GetCurrentFace();
}
