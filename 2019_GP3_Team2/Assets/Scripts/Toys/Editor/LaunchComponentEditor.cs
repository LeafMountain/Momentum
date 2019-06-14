using UnityEditor;
using UnityEngine;

[CustomEditor(typeof(LaunchComponent))]
public class LaunchComponentEditor : Editor
{
    private Tool _latestTool;
    private GUIStyle _style = new GUIStyle();

    private LaunchComponent _launchComponent;

    private void OnEnable()
    {
        _style.fontStyle = FontStyle.Bold;
        _style.fontSize = 20;
        _style.normal.textColor = Color.Lerp(Color.white, Color.blue, 0.5f);

        _latestTool = Tools.current;

        Tools.current = Tool.None;

        _launchComponent = target as LaunchComponent;
        _launchComponent.UpdateDirectionArrow();
    }

    private void OnDisable()
    {
        Tools.current = _latestTool;
    }

    private void OnSceneGUI()
    {
        //Tools.current = Tool.None;
        EditorGUI.BeginChangeCheck();

        //Vector3 anchorPoint = _launchComponent.transform.position;
        Handles.Label(_launchComponent.target, "Target", _style);
        Vector3 newPosition = Handles.PositionHandle(_launchComponent.target, Quaternion.identity);
        Undo.RecordObject(_launchComponent, "Target Handle");


        if (EditorGUI.EndChangeCheck())
        {
            _launchComponent.target = newPosition;
            _launchComponent.UpdateDirectionArrow();
        }
    }

    public override void OnInspectorGUI()
    {
        if (GUILayout.Button("Reset Target Position"))
        {
            _launchComponent.ResetTargetPosition();
        }

        if (GUILayout.Button("Update Arrow Rotation"))
        {
            _launchComponent.UpdateDirectionArrow();
        }

        base.OnInspectorGUI();
    }
}
