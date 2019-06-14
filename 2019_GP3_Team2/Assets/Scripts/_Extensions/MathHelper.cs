using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public static class MathHelper
{
    public static float Frac(float value) => value - Mathf.Floor(value);
}
