using UnityEngine;

public class BezierCurveHelper
{
    public static Vector3 GetPointOnLinearCurve(float t, Vector3 p0, Vector3 p1)
    {
        return (1 - t) * p0 + t * p1;
    }

    public static Vector3 GetPointOnQuadricCurve(float t, Vector3 p0, Vector3 p1, Vector3 p2)
    {
        return p1 + ((1 - t) * (1 - t)) * (p0 - p1) + (t * t) * (p2 - p1);
    }

    public static Vector3 GetPointOnCubicCurve(float t, Vector3 p0, Vector3 p1, Vector3 p2, Vector3 p3)
    {
        float tt = (1 - t) * (1 - t);
        float ttt = (1 - t) * (1 - t) * (1 - t);
        return ttt * p0 + 3 * tt * t * p1 + 3 * (1 - t) * (t * t) * p2 + (t * t * t) * p3;
    }

    public static void DrawDebugQuadricCurve(int segments, Vector3 p0, Vector3 p1, Vector3 p2, Color color)
    {
        Vector3 lastPoint = p0;
        for (int i = 0; i < segments; i++)
        {
            float percentage = i / (segments - 1.0f);
            Vector3 nextPoint = GetPointOnQuadricCurve(percentage, p0, p1, p2);
            Debug.DrawLine(lastPoint, nextPoint, color);
            lastPoint = nextPoint;
        }
    }

    public static void DrawDebugQuadricCurve(int segments, Vector3 p0, Vector3 p1, Vector3 p2, Vector3 p3, Color color)
    {
        Vector3 lastPoint = p0;
        for (int i = 0; i < segments; i++)
        {
            float percentage = i / (segments - 1.0f);
            Vector3 nextPoint = GetPointOnCubicCurve(percentage, p0, p1, p2, p3);
            Debug.DrawLine(lastPoint, nextPoint, color);
            lastPoint = nextPoint;
        }
    }
}
