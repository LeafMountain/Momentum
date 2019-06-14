using UnityEditor;
using UnityEngine;

[CustomEditor(typeof(AIBehaviourComponent))]
public class AIBehaviourComponentEditor : Editor
{
    private bool _visibleEvents = false;
    private bool _visibleRersponses = false;
    private bool _visibleFaces = false;

    public override void OnInspectorGUI()
    {

        DrawDefaultInspector();
        SerializedObject so = serializedObject;

        // Current Mood
        {
            SerializedProperty propertyCurrentMood = so.FindProperty("currentMood");
            so.Update();

            GUILayout.Space(15);

            GUILayout.BeginVertical(EditorStyles.helpBox);
            {
                EditorGUILayout.PropertyField(propertyCurrentMood);
            }
            GUILayout.EndVertical();
            so.ApplyModifiedProperties();
        }

        // Events
        {
            SerializedProperty propertyDeathEvent = so.FindProperty("deathEvent");
            SerializedProperty propertyFinishSectionEvent = so.FindProperty("finishSectionEvent");
            SerializedProperty propertyTooLateEvent = so.FindProperty("tooLateEvent");
            SerializedProperty propertyStandingStillEvent = so.FindProperty("standingStillEvent");

            so.Update();

            GUILayout.Space(15);
            GUILayout.Label("Events:", EditorStyles.boldLabel);
            _visibleEvents = EditorGUILayout.Foldout(_visibleEvents, _visibleEvents ? "Hide" : "Show");

            if (_visibleEvents)
            {
                GUILayout.BeginVertical(EditorStyles.helpBox);
                {
                    EditorGUILayout.PropertyField(propertyDeathEvent);
                    EditorGUILayout.PropertyField(propertyFinishSectionEvent);
                    EditorGUILayout.PropertyField(propertyTooLateEvent);
                    EditorGUILayout.PropertyField(propertyStandingStillEvent);
                }
                GUILayout.EndVertical();
            }
            so.ApplyModifiedProperties();
        }

        // AI Responses
        {
            SerializedProperty propertyDeathResponse = so.FindProperty("deathResponse");
            SerializedProperty propertyFinishSectionResponse = so.FindProperty("finishSectionResponse");
            SerializedProperty propertyTooLateResponse = so.FindProperty("tooLateResponse");
            SerializedProperty propertyStandingStillResponse = so.FindProperty("standingStillResponse");


            so.Update();

            GUILayout.Space(10);
            GUILayout.Label("Responses:", EditorStyles.boldLabel);
            _visibleRersponses = EditorGUILayout.Foldout(_visibleRersponses, _visibleRersponses ? "Hide" : "Show");

            if (_visibleRersponses)
            {
                GUILayout.BeginVertical(EditorStyles.helpBox);
                {
                    EditorGUILayout.PropertyField(propertyDeathResponse);
                    EditorGUILayout.PropertyField(propertyFinishSectionResponse);
                    EditorGUILayout.PropertyField(propertyTooLateResponse);
                    EditorGUILayout.PropertyField(propertyStandingStillResponse);
                }
                GUILayout.EndVertical();
            }
            so.ApplyModifiedProperties();
        }

    }
}
