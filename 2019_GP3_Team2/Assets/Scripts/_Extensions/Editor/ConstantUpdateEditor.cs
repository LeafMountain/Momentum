using UnityEditor;
using UnityEngine;

[InitializeOnLoad]
class ConstantUpdateEditor
{
    static ConstantUpdateEditor()
    {
        EditorApplication.update += Update;
    }

    static void Update()
    {
        SceneView.RepaintAll();
    }
}
