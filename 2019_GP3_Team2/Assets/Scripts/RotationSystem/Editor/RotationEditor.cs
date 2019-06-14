// using UnityEditor;
// using UnityEngine;

// [CustomEditor(typeof(RotationComponent))]
// public class RotationEditor : Editor
// {
//     private Vector3 _pivotHandle;

//     private RotationComponent _component;
//     private Tool _lastTool = Tool.None;

//     private void OnEnable()
//     {
//         _component = target as RotationComponent;
//         _pivotHandle = _component.transform.position;
//     }

//     private void OnDisable()
//     {
//         Tools.current = _lastTool;
//         _component._changePivot = false;
//     }

//     private void OnSceneGUI()
//     {
//         ShowPivot();
//     }

//     private bool ShowPivot()
//     {
//         if (_component._changePivot)
//         {
//             DrawPivotHandle();
//             _lastTool = Tools.current;
//             Tools.current = Tool.None;
//             return true;
//         }
//         else
//         {
//             Tools.current = Tool.Move;
//             return false;
//         }
//     }

//     private void DrawPivotHandle()
//     {
//         Vector3 pivotHandle = _component.GetWorldPivotPosition();

//         Handles.DrawLine(_component.transform.position, pivotHandle);

//         Vector3 pivotWorldPos = Handles.PositionHandle(pivotHandle, Quaternion.identity);
//         _component.pivot = pivotWorldPos - _component.transform.position;
//     }
// }
