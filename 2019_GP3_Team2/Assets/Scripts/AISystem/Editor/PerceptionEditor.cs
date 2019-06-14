using UnityEditor;
using UnityEditor.IMGUI.Controls;
using UnityEngine;

[CustomEditor(typeof(AIPerception))]
public class PerceptionEditor : Editor
{
    private ArcHandle _arcHandle = new ArcHandle();

    private void OnEnable()
    {
        _arcHandle.fillColor = new Color(0f, 1f, 0f, 0.25f);
        _arcHandle.wireframeColor = _arcHandle.fillColor;

        _arcHandle.angleHandleColor = Color.red;
        _arcHandle.radiusHandleColor = Color.red;
    }

    private void OnSceneGUI()
    {
        if(!target) return;

        Color oldColor = Handles.color;

        AIPerception perception = target as AIPerception;

        float halfFeildOfView = perception.fieldOfViewAngle * 0.5f;
        float coneDirection = -90f;

        //Calculate rays
        Quaternion leftRayRotation = Quaternion.AngleAxis(-halfFeildOfView + coneDirection, Vector3.up);
        Quaternion rightRayRotation = Quaternion.AngleAxis(halfFeildOfView + coneDirection, Vector3.up);

        Vector3 leftRayDirection = leftRayRotation * perception.transform.right * perception.perceptionRadius;
        Vector3 rightRayDirection = rightRayRotation * perception.transform.right * perception.perceptionRadius;

        _arcHandle.angle = perception.fieldOfViewAngle;
        _arcHandle.radius = perception.perceptionRadius;

        Vector3 handleDirection = leftRayDirection;
        Vector3 handleNormal = Vector3.Cross(handleDirection, perception.transform.forward);

        //Translation, rotation and scaling matrix
        Matrix4x4 handleMatrix = Matrix4x4.TRS(perception.transform.position, Quaternion.LookRotation(handleDirection, handleNormal), Vector3.one);

        // Need this to clean up scope and refresh the Gizmo
        using (new Handles.DrawingScope(handleMatrix))
        {
            EditorGUI.BeginChangeCheck();
            _arcHandle.DrawHandle();
            if (EditorGUI.EndChangeCheck())
            {
                Undo.RecordObject(perception, "Perception Setting");

                perception.fieldOfViewAngle = Mathf.Clamp(_arcHandle.angle, 0f, 350.99f);
                perception.perceptionRadius = Mathf.Max(_arcHandle.radius, 1f);
            }
        }

        Handles.color = new Color(0.25f, 0.25f, 0.25f, 0.5f);
        Handles.DrawSolidArc(perception.transform.position, Vector3.up, rightRayDirection, 360f - perception.fieldOfViewAngle, perception.perceptionRadius);

        Handles.color = oldColor;
    }
}
