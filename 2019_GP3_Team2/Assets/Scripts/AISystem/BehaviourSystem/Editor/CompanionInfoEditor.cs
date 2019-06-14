using UnityEditor;
using UnityEngine;


[CustomEditor(typeof(ResponseData))]
public class CompanionInfoEditor : Editor
{
    public override void OnInspectorGUI()
    {
        GUIStyle headerLable = new GUIStyle(EditorStyles.boldLabel);
        headerLable.alignment = TextAnchor.LowerCenter;
        headerLable.fontSize = 16;

        GUILayout.Label("COMPANION DIALOG", headerLable);
        EditorGUILayout.Space();

        EditorGUILayout.HelpBox("Here you create text field of what the companion will say, depending on the mood.", MessageType.Info);
        EditorGUILayout.Space();

        base.OnInspectorGUI();
    }
}
