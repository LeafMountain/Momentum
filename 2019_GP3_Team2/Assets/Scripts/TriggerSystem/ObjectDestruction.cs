using UnityEngine;

[AddComponentMenu("(つ♥v♥)つ/Triggers/Destroy Object")]
public class ObjectDestruction : MonoBehaviour
{
    public void DestroyTrigger() => Destroy(gameObject);
}