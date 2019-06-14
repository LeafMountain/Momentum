// using System.Collections;
// using System.Collections.Generic;
// using UnityEditor;
// using UnityEditor.IMGUI.Controls;
// using UnityEngine;

// [CustomEditor(typeof(ShootComponent))]
// public class ShootEditor : Editor
// {
//     private ArcHandle _arcHandle = new ArcHandle();

//     private void OnEnable()
//     {
//         _arcHandle.fillColor = new Color(0f, 1f, 0f, 0.25f);
//         _arcHandle.wireframeColor = _arcHandle.fillColor;

//         _arcHandle.angleHandleColor = Color.blue;
//         _arcHandle.radiusHandleColor = Color.blue;
//     }

//     private void OnSceneGUI()
//     {
//         if (!target) return;

//         Color oldColor = Handles.color;

//         ShootComponent component = target as ShootComponent;

//         float halfFeildOfView = component.aimAssistMaxAngleToAssist * 0.5f;
//         float coneDirection = -90f;

//         //Calculate rays
//         Quaternion leftRayRotation = Quaternion.AngleAxis(-halfFeildOfView + coneDirection, Vector3.up);
//         Quaternion rightRayRotation = Quaternion.AngleAxis(halfFeildOfView + coneDirection, Vector3.up);

//         Vector3 leftRayDirection = leftRayRotation * component.transform.right * component.aimAssistRadius;
//         Vector3 rightRayDirection = rightRayRotation * component.transform.right * component.aimAssistRadius;

//         _arcHandle.angle = component.aimAssistMaxAngleToAssist;
//         _arcHandle.radius = component.aimAssistRadius;

//         Vector3 handleDirection = leftRayDirection;
//         Vector3 handleNormal = Vector3.Cross(handleDirection, component.transform.forward);

//         //Translation, rotation and scaling matrix
//         Matrix4x4 handleMatrix = Matrix4x4.TRS(component.transform.position, Quaternion.LookRotation(handleDirection, handleNormal), Vector3.one);

//         // Need this to clean up scope and refresh the Gizmo
//         using (new Handles.DrawingScope(handleMatrix))
//         {
//             EditorGUI.BeginChangeCheck();
//             _arcHandle.DrawHandle();
//             if (EditorGUI.EndChangeCheck())
//             {
//                 Undo.RecordObject(component, "Shoot Sight Setting");

//                 component.aimAssistMaxAngleToAssist = Mathf.Clamp(_arcHandle.angle, 0f, 350.99f);
//                 component.aimAssistRadius = Mathf.Max(_arcHandle.radius, 1f);
//             }
//         }
//         Handles.color = oldColor;
//     }
// }
