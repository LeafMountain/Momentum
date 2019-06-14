using System;
using UnityEngine;

[Serializable]
public struct MinMaxFloat
{
    public float Min;
    public float Max;

    public float Range
    {
        get { return Mathf.Abs(Max - Min); }
    }

    public MinMaxFloat(float min, float max)
    {
        Min = min;
        Max = max;
    }
  
    public float ClampAngle(float rotationAverage)
    {
        rotationAverage = rotationAverage % 360;
        if ((rotationAverage >= -360f) && (rotationAverage <= 360f))
        {
            if (rotationAverage < -360f)
                rotationAverage += 360f;

            if (rotationAverage > 360f)
                rotationAverage -= 360f;

        }

        return Mathf.Clamp(rotationAverage, Min, Max);
    }

}
