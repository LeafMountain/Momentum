using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MinMaxAttribute : PropertyAttribute
{
    public float minLimit = 0f;
    public float maxLimit = 10f;

    public MinMaxAttribute(float min, float max)
    {
        minLimit = min;
        maxLimit = max;
    }
}
