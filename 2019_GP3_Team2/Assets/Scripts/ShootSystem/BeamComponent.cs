using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[RequireComponent(typeof(LineRenderer))]
[DisallowMultipleComponent, AddComponentMenu("(つ♥v♥)つ/VFX/Curved LineRenderer VFX")]
public class BeamComponent : MonoBehaviour
{
    public enum SnapMode
    {
        ClosestPoint,
        Pivot
    }

    [Header("Settings")]
    [Tooltip("How far it can bend")]
    public float bendDistance = 2;
    [Tooltip("How many segments the beam have = How rounded the beam is if bended")]
    public int segments = 10;

    public SnapMode snapMode;

    [Tooltip("How long the beam lifetime is.\nIf it's 0 the beam will never stop")]
    public float lifetime = 0;

    [Header("Position")]
    [Tooltip("Where the beam should start")]
    [SerializeField] Transform _beamOrigin;
    [Tooltip("Where the beam should end")]
    [SerializeField] Transform target;

    LineRenderer _lineRenderer;
    Vector3 _startPosition;
    Vector3 _midPosition;
    Vector3 _endPosition;

    bool _dirty = true;
    IEnumerator _currentCountdown;

    void Awake()
    {
        _lineRenderer = GetComponent<LineRenderer>();
        if (!target)
            this.enabled = false;
    }

    public void SetTarget(GameObject target)
    {
        if (target)
        {
            this.enabled = true;
            this.target = target.transform;
            StopAllCoroutines();

            if (lifetime != 0)
                StartCoroutine(StopBeam(lifetime));
        }
    }

    public void SetPositions(Vector3 startPosition, Vector3 midPosition, Vector3 endPosition)
    {
        SetStart(startPosition);
        SetMid(midPosition);
        SetEnd(endPosition);
    }

    public void SetStart(Vector3 position)
    {
        _startPosition = position;
        _dirty = true;
    }

    public void SetMid(Vector3 position)
    {
        _midPosition = position;
        _dirty = true;
    }

    public void SetEnd(Vector3 position)
    {
        _endPosition = position;
        _dirty = true;
    }

    public void SetMaterial(Material material)
    {
        _lineRenderer.material = material;
    }

    void LateUpdate()
    {
        if (!_beamOrigin)
            return;

        _startPosition = _beamOrigin.position;
        _midPosition = _startPosition + _beamOrigin.transform.forward * bendDistance;

        /*
                Collider[] colliders = _closestDotObject.GetComponents<Collider>();
        Vector3 point = colliders[0].ClosestPoint(shootOrigin.position);
        float distanceToPoint = Vector3.Distance(shootOrigin.position, point);
        // Get closest collider
        for (int i = 1; i < colliders.Length; i++)
        {
            Vector3 newPoint = colliders[i].ClosestPoint(shootOrigin.position);
            float newDistanceToPoint = Vector3.Distance(shootOrigin.position, newPoint);
            if (distanceToPoint > newDistanceToPoint)
            {
                point = newPoint;
                distanceToPoint = newDistanceToPoint;
            }
        }
         */

        if (snapMode == SnapMode.ClosestPoint)
        {
            MeshCollider meshCollider = target.GetComponent<MeshCollider>();
            if (meshCollider && !meshCollider.convex)
                _endPosition = meshCollider.bounds.ClosestPoint(_startPosition);
            else
                _endPosition = target.GetComponent<Collider>().ClosestPoint(_startPosition);
        }
        else
            _endPosition = target.position;

        _lineRenderer.positionCount = segments;

        for (int i = 0; i < segments; i++)
        {
            _lineRenderer.SetPosition(i, BezierCurveHelper.GetPointOnQuadricCurve(i / (segments - 1.0f), _startPosition, _midPosition, _endPosition));
        }
    }

    public void OnEnable()
    {
        _lineRenderer.enabled = true;
    }

    public void OnDisable()
    {
        _lineRenderer.enabled = false;
    }

    IEnumerator StopBeam(float delay)
    {
        yield return new WaitForSeconds(delay);
        this.enabled = false;
    }

#if UNITY_EDITOR
    void OnDrawGizmos()
    {
        BezierCurveHelper.DrawDebugQuadricCurve(segments, _startPosition, _midPosition, _endPosition, Color.red);
    }
#endif
}
