using UnityEditor;
using UnityEngine;

#if UNITY_EDITOR
public static class EditorHelper
{
    static float lastTime;

    public static float editorDeltaTime
    {
        get
        {
            float deltaTime = (float)EditorApplication.timeSinceStartup - lastTime;
            lastTime = (float)EditorApplication.timeSinceStartup;
            // Debug.Log(deltaTime);
            return deltaTime;
        }
    }

    public static float editorFixedDeltaTime
    {
        get
        {
            return 1 / 5;
        }
    }
}
#endif