using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;


public static class DebugHelper
{
    // Start + End
    public static void DrawArrow(Vector3 start, Vector3 end, float arrowHeadLength = 1.0f)
    {
        Vector3 difVector = end - start;
        DrawArrow(start, difVector.normalized, Color.white, Color.white, difVector.magnitude, arrowHeadLength);
    }

    public static void DrawArrow(Vector3 start, Vector3 end, Color color, float arrowHeadLength = 1.0f)
    {
        Vector3 difVector = end - start;
        DrawArrow(start, difVector.normalized, color, color, difVector.magnitude, arrowHeadLength);
    }

    public static void DrawArrow(Vector3 start, Vector3 end, Color arrowColor, Color arrowHeadColor, float arrowHeadLength = 1.0f)
    {
        Vector3 difVector = end - start;
        DrawArrow(start, difVector.normalized, arrowColor, arrowHeadColor, difVector.magnitude, arrowHeadLength);
    }

    // Start + Direction
    public static void DrawArrow(Vector3 start, Vector3 direction, float arrowLength = 1.0f, float arrowHeadLength = 1.0f)
    {
        DrawArrow(start, direction, Color.white, Color.white, arrowLength, arrowHeadLength);
    }

    public static void DrawArrow(Vector3 start, Vector3 direction, Color color, float arrowLength = 1.0f, float arrowHeadLength = 1.0f)
    {
        DrawArrow(start, direction, color, color, arrowLength, arrowHeadLength);
    }

    public static void DrawArrow(Vector3 start, Vector3 direction, Color arrowColor, Color arrowHeadColor, float arrowLength = 1.0f, float arrowHeadLength = 1.0f)
    {
        //return;
        if (direction == Vector3.zero) return;
        if (float.IsNaN(direction.x) || float.IsNaN(direction.y) || float.IsNaN(direction.z)) return;

        Vector3 tipPos = start + direction * arrowLength;

        Vector3 right = Quaternion.LookRotation(direction) * Quaternion.Euler(0, 180 + 20, 0) * new Vector3(0, 0, 1);
        Vector3 left = Quaternion.LookRotation(direction) * Quaternion.Euler(0, 180 - 20, 0) * new Vector3(0, 0, 1);
        Vector3 up = Quaternion.LookRotation(direction) * Quaternion.Euler(180 + 20, 0, 1) * new Vector3(0, 0, 1);
        Vector3 down = Quaternion.LookRotation(direction) * Quaternion.Euler(180 - 20, 0, 1) * new Vector3(0, 0, 1);

        Debug.DrawLine(start, tipPos, arrowColor);
        Debug.DrawLine(tipPos, tipPos + arrowHeadLength * right, arrowHeadColor);
        Debug.DrawLine(tipPos, tipPos + arrowHeadLength * left, arrowHeadColor);
        Debug.DrawLine(tipPos, tipPos + arrowHeadLength * up, arrowHeadColor);
        Debug.DrawLine(tipPos, tipPos + arrowHeadLength * down, arrowHeadColor);
    }
}
