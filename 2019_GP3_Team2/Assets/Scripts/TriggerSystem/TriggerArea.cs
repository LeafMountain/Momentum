using UnityEngine;
using UnityEngine.Events;

[DisallowMultipleComponent, AddComponentMenu("(つ♥v♥)つ/Triggers/Area Trigger"), RequireComponent(typeof(BoxCollider))]
public class TriggerArea : MonoBehaviour
{
    public Vector3 size;

    [Header("Events")]
    public UnityEventGameObject TriggerEnter;
    public UnityEventGameObject TriggerStay;
    public UnityEventGameObject TriggerExit;

    [SerializeField] bool _visualizeWhenNotSelected = true;
    [SerializeField] Color _gizmoColor = new Color(0, 255, 255, .5f);


    void Start()
    {
        GetComponent<BoxCollider>().size = size;
    }

    void OnTriggerEnter(Collider other)
    {
        if (!other.CompareTag("Player")) return;

        TriggerEnter.Invoke(other.gameObject);
    }

    void OnTriggerStay(Collider other)
    {
        if (!other.CompareTag("Player")) return;
        TriggerStay.Invoke(other.gameObject);
    }

    void OnTriggerExit(Collider other)
    {
        if (!other.CompareTag("Player")) return;
        TriggerExit.Invoke(other.gameObject);
    }

    void Reset()
    {
        GetComponent<Collider>().isTrigger = true;
    }

#if UNITY_EDITOR
    void OnDrawGizmos()
    {
        Gizmos.matrix = transform.localToWorldMatrix;
        if (_visualizeWhenNotSelected)
        {
            Gizmos.color = _gizmoColor;
            Gizmos.DrawCube(Vector3.zero, size);
            Color outline = _gizmoColor;
            outline.a = 1;
            Gizmos.color = outline;
            Gizmos.DrawWireCube(Vector3.zero, size);
        }
    }

    void OnDrawGizmosSelected()
    {
        Gizmos.matrix = transform.localToWorldMatrix;
        Gizmos.color = new Color(0, 255, 255, .5f);
        GetComponent<BoxCollider>().size = size;

        if (!_visualizeWhenNotSelected)
        {
            Gizmos.color = _gizmoColor;
            Gizmos.DrawCube(Vector3.zero, size);
            Color outline = _gizmoColor;
            outline.a = 1;
            Gizmos.color = outline;
            Gizmos.DrawWireCube(Vector3.zero, size);
        }
    }
#endif
}
