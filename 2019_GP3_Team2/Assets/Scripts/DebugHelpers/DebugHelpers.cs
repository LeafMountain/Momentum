using System.Collections;
using System.Collections.Generic;
using UnityEngine;


[DisallowMultipleComponent, AddComponentMenu("(つ♥v♥)つ/Debug/Print Debug")]
public class DebugHelpers : MonoBehaviour
{
    public void Print(GameObject go)
    {
        Debug.Log(go?.name);
    }

    public void Print(string text)
    {
        Debug.Log("[" + transform.name + "] " + text);
    }
}
