using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;

[DisallowMultipleComponent, AddComponentMenu("(つ♥v♥)つ/AI Behaviour/AI Perception")]
public class AIPerception : MonoBehaviour
{
    [Header("Values")]
    [Tooltip("How far the AI sight can reach")]
    public float perceptionRadius = 1f;

    [Range(0f, 360f)]
    [Tooltip("The field of view the perception AI see")]
    public float fieldOfViewAngle = 100f;

    [Space(10f)]

    [Header("Materials for Debugging")]
    [SerializeField] private Material _seenMaterial;
    [SerializeField] private Material _unseenMaterial;

    [Space(10f)]

    [Tooltip("The layer the perception will work with")]
    [SerializeField]
    private LayerMask _perceptionMask;

    [Header("Event")]
    public UnityEvent OnSeen;

    //Every object we saw last frame
    private List<Collider> _previouslySeenColliders = new List<Collider>(); 

   
    void Update()
    {
        for (int i = 0; i < _previouslySeenColliders.Count; i++)
            _previouslySeenColliders[i].GetComponent<Renderer>().sharedMaterial = _unseenMaterial;

        _previouslySeenColliders.Clear();

        Collider[] overlappingSpheres = Physics.OverlapSphere(transform.position, perceptionRadius, _perceptionMask, QueryTriggerInteraction.Ignore);
        _previouslySeenColliders.AddRange(overlappingSpheres);

        for (int i = 0; i < _previouslySeenColliders.Count; i++)
        {
            Vector3 direction = _previouslySeenColliders[i].transform.position - transform.position;
            float angle = Vector3.Angle(direction, transform.forward);

            if (angle <= fieldOfViewAngle * 0.5f)
            {
                OnSeen.Invoke();
                _previouslySeenColliders[i].GetComponent<Renderer>().sharedMaterial = _seenMaterial;
            }
           
        }
    }
   
#if UNITY_EDITOR 

    private void OnDrawGizmosSelected()
    {
        if (!Application.isPlaying) return;

        Color oldColor = Gizmos.color;

        float halfFeildOfView = fieldOfViewAngle * 0.5f;
        float coneDirection = -90f;

        Quaternion leftRayRotation = Quaternion.AngleAxis(-halfFeildOfView + coneDirection, Vector3.up);
        Quaternion rightRayRotation = Quaternion.AngleAxis(halfFeildOfView + coneDirection, Vector3.up);

        Vector3 leftRayDirection = leftRayRotation * transform.right * perceptionRadius;
        Vector3 rightRayDirection = rightRayRotation * transform.right * perceptionRadius;

        // Green
        UnityEditor.Handles.color = new Color(0f, 1f, 0f, 0.25f); 
        UnityEditor.Handles.DrawSolidArc(transform.position, Vector3.up, leftRayDirection, fieldOfViewAngle, perceptionRadius);

        // Red
        UnityEditor.Handles.color = new Color(0.25f, 0.25f, 0.25f, 0.5f); 
        UnityEditor.Handles.DrawSolidArc(transform.position, Vector3.up, rightRayDirection, 360f - fieldOfViewAngle, perceptionRadius);

        Gizmos.color = oldColor;
    }

#endif

}
