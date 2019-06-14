using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public static class VectorExtension
{
    public static Vector3 GetCenterPoint(Vector3[] points)
    {
        Vector3 anchor = new Vector3(0, 0, 0);
        int pointAmount = points.Length;

        foreach (Vector3 point in points)
            anchor += point;

        anchor /= pointAmount;
        return anchor;
    }
}
