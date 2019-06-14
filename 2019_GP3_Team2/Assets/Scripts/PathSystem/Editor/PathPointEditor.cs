using UnityEditor;
using UnityEngine;

[CustomEditor(typeof(PathPoint))]
public class PathPointEditor : Editor
{
    private Tool _latestTool;
    private GUIStyle _style = new GUIStyle();

    private Vector3 _position;
    private int _currentTarget;
    private PathPoint _pathPoint;

    private bool _oldEditPath;

    public override void OnInspectorGUI()
    {
        EditorGUILayout.HelpBox("OBS: this will not manipulate the time of the object!", MessageType.Warning);
        base.OnInspectorGUI();
    }

    private void OnEnable()
    {
        _style.fontStyle = FontStyle.Bold;
        _style.fontSize = 20;
        _style.normal.textColor = Color.Lerp(Color.white, Color.blue, 0.5f);

        _latestTool = Tools.current;
        Tools.current = Tool.None;

        _pathPoint = target as PathPoint;
    }

    private void OnDisable()
    {
        Tools.current = _latestTool;
        // _pathPoint.editPath = true;
    }

    private void OnSceneGUI()
    {
        if (_pathPoint.editPath)
        {
            Tools.current = Tool.None;

            for (int i = 0; i < _pathPoint.points.Length; i++)
            {
                EditorGUI.BeginChangeCheck();

                Vector3 anchorPoint = _pathPoint.transform.position;
                Handles.Label(_pathPoint.points[i] + anchorPoint, i.ToString(), _style);
                Vector3 newPosition = Handles.PositionHandle(_pathPoint.points[i] + anchorPoint, Quaternion.identity);

                if (EditorGUI.EndChangeCheck())
                {
                    Undo.RecordObject(_pathPoint, "Move Handle");
                    if (i == 0)
                    {
                        // TODO: Here is the BUG (check bug-report "Path: Move cube and undo will move the whole path")
                        _pathPoint.SetAnchor(newPosition);
                    }
                    else
                        _pathPoint.points[i] = newPosition - anchorPoint;
                }
            }
        }
        else
        {
            if (_oldEditPath != _pathPoint.editPath)
            {
                _oldEditPath = _pathPoint.editPath;
                Tools.current = Tool.Move;
            }
        }
    }
}