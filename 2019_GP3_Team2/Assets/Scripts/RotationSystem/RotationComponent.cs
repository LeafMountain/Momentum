using System.Collections;
using System.Collections.Generic;
using UnityEditor;
using UnityEngine;
using UnityEngine.Events;

[DisallowMultipleComponent, AddComponentMenu("(つ♥v♥)つ/Movables/Rotation Movement")]
public class RotationComponent : MonoBehaviour
{
    [Header("Rotation Setup")]
    [SerializeField] Vector3 axis;
    [SerializeField] float rotationSpeed = 20.0f;
    [SerializeField, Range(1, 360)] int snapFrequency;
    [SerializeField] int eventIndex = 0;

    [Header("Events")]
    [SerializeField] UnityEvent onEventIndex;

    private float _timeScale = 1.0f;
    private Vector3[] _snapPositions;
    private int _closestIndex = 0;
    private Vector3 _checkVec;

    void Start()
    {
        if(snapFrequency < 1)
        {
            snapFrequency = 1;
        }
        
        _snapPositions = new Vector3[snapFrequency];
        _checkVec = Vector3.Cross(transform.up, axis.normalized);

        for (int i = 0; i < snapFrequency; i++)
        {
            _snapPositions[i] = GetPointOnCircle(i);
        }
    }

    void Update()
    {
        if (axis.normalized == transform.up)
        {
            _checkVec = Vector3.Cross(transform.forward, axis.normalized);
        }
        else
        {
            _checkVec = Vector3.Cross(transform.up, axis.normalized);
        }

        DebugHelper.DrawArrow(transform.position, _checkVec, Color.blue, 2.5f, .1f);

        if (_timeScale < 0.01f)
        {
            float angle = Vector3.SignedAngle(_checkVec, _snapPositions[_closestIndex], axis.normalized);
            float angleSpeed = rotationSpeed * _timeScale * Time.deltaTime;

            if (angle > 0.1f)
            {
                transform.Rotate(axis.normalized, rotationSpeed * Time.deltaTime);

            }
            else if (angle < -0.1f)
            {
                transform.Rotate(axis.normalized, -rotationSpeed * Time.deltaTime);

            }
        }
        else
        {
            float angle = rotationSpeed * _timeScale * Time.deltaTime;
            transform.Rotate(axis.normalized, angle);
        }
    }

    public void SetTimeScale(float value)
    {
        _timeScale = value;
        if (_timeScale < 0.01f)
        {
            float closestAngle = Mathf.Infinity;
            for (int i = 0; i < snapFrequency; i++)
            {
                float angle = Vector3.Angle(_snapPositions[i], _checkVec);

                if (angle < closestAngle)
                {
                    closestAngle = angle;
                    _closestIndex = i;
                }
            }

            // DebugHelper.DrawArrow(transform.position, _snapPositions[_closestIndex], Color.red, 2, .1f);

            if (_closestIndex == eventIndex % snapFrequency)
            {
                onEventIndex.Invoke();
            }
        }
    }

#if UNITY_EDITOR
    void OnDrawGizmos()
    {
        for (int i = 0; i < snapFrequency; i++)
        {
            Vector3 newPos = GetPointOnCircle(i);

            DebugHelper.DrawArrow(transform.position, newPos, Color.green, 1, .1f);
        }

        Vector3 eventPos = GetPointOnCircle(eventIndex);
        DebugHelper.DrawArrow(transform.position, eventPos, Color.yellow, 1.2f, .1f);
    }
#endif

    public Vector3 GetPointOnCircle(int index)
    {
        float theta = (360f / (float)snapFrequency) * (float)index;
        Vector3 tmp = (axis.normalized - Vector3.one) * -1;
        return Quaternion.AngleAxis(theta, axis.normalized) * tmp;
    }
}
