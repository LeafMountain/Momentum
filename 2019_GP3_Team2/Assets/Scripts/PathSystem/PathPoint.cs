using System.Collections;
using System.Collections.Generic;
using UnityEditor;
using UnityEngine;

public class PathPoint : MonoBehaviour
{
    [Header("Checks")]
    [Tooltip("True: show/use handles on each points \nFalse: hide the handles")]
    public bool editPath = true;

    [Space(15)]
    public Vector3[] points = new Vector3[1];

    private Vector3 _anchorPoint;

    [HideInInspector] public bool loop = false;

    void Awake()
    {
        _anchorPoint = transform.position;
    }

    // A is the percentage along the path. Find a better name
    public Vector3 GetPercentageAlongPath(float percentage)
    {
        if(_anchorPoint == Vector3.zero) _anchorPoint = transform.position;

        float totalLength = GetLength();
        float length = 0;
        Vector3 tempPos = Vector3.zero;

        for (int i = 0; i < points.Length; i++)
        {
            float currentPercentage = length / totalLength;
            length += (points[i] - points[(i + 1) % points.Length]).magnitude;
            float percentageAlong = length / totalLength;

            if(percentageAlong > percentage)
            {
                tempPos = GetPositionBetweenPoints(points[i], points[(i + 1) % points.Length], PercentageBetween(currentPercentage, percentageAlong, percentage));
                break;
            }
        }

        tempPos += _anchorPoint;
        return tempPos;
    }

    public Vector3 GetMetersAlongPath(float meters)
    {
        float totalLength = GetLength();
        return GetPercentageAlongPath(meters / totalLength);
    }

    float PercentageBetween(float a, float b, float value)
    {
        return (value - a) / (b - a);
    }

    Vector3 GetPositionBetweenPoints(Vector3 pointA, Vector3 pointB, float percentage)
    {
        return pointA + (pointB - pointA) * percentage;
    }

    public float GetLength()
    {
        float length = 0;
        float pointsLength = loop ? points.Length : points.Length - 1;
        for (int i = 0; i < pointsLength; i++)
        {
            length += (points[i] - points[(i + 1) % points.Length]).magnitude;
        }
        return length;
    }

    public Vector3 GetPointInWorldSpace(int index)
    {
        index = Mathf.Clamp(index, 0, points.Length -1);
        return points[index] + _anchorPoint;
    }
    
    public void SetAnchor(Vector3 position)
    {
        Vector3 deltaMovement = position - transform.position;
        transform.position = position;
        _anchorPoint = position;
        points[0] = Vector3.zero;

        for (int i = 1; i < points.Length; i++)
            points[i] -= deltaMovement;
        
    }

#if UNITY_EDITOR
    private void OnDrawGizmos()
    {
        if(_anchorPoint == Vector3.zero)
            _anchorPoint = transform.position;

        Gizmos.color = Color.blue;

        for (int i = 0; i < points.Length - 1; i++)
            Gizmos.DrawLine(points[i] + _anchorPoint, points[i + 1] + _anchorPoint);
    }
#endif
}
