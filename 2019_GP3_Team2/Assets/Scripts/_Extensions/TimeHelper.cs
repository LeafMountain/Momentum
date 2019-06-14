using UnityEditor;
using UnityEngine;

#if UNITY_EDITOR
[InitializeOnLoad]
public class TimeHelper
{
    static float _gizmoLastTime;
    public static float gizmoDeltaTime;

    static TimeHelper()
    {
        EditorApplication.update += UpdateGizmoTime;
    }

    static void UpdateGizmoTime()
    {
        gizmoDeltaTime = Time.realtimeSinceStartup - _gizmoLastTime;
        _gizmoLastTime = Time.realtimeSinceStartup;
    }
}
#endif