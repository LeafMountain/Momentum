using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;

public class ReplaceGameObjectTool : EditorWindow
{

    GameObject replacer;
    bool useSelectionScale = true;

    [MenuItem("Window/Replace")]
    public static void ShowWindow()
    {
        EditorWindow.GetWindow<ReplaceGameObjectTool>("Replace");
    }

    void OnGUI()
    {
        GUILayout.Label("Game Object to replace selection", EditorStyles.boldLabel);
        GUILayout.Toggle(useSelectionScale, "Use Selections Scale");

        replacer = (GameObject)EditorGUILayout.ObjectField(replacer, typeof(GameObject), true);

        if (GUILayout.Button("Replace Selected Game Objects"))
        {

            GameObject[] objects = Selection.gameObjects;

            // Undo.RecordObjects(objects, "Undo Mass Replacement");

            List<GameObject> newGOs = new List<GameObject>();

            if (replacer)
            {
                foreach (GameObject go in objects)
                {
                    Vector3 pos = go.transform.position;
                    Quaternion rot = go.transform.rotation;
                    Vector3 scale = go.transform.localScale;
                    Transform parent = go.transform.parent;
                    string name = go.name;

                    Undo.DestroyObjectImmediate(go);

                    // GameObject newGo = Instantiate(replacer, pos, rot, parent);
                    GameObject prefab = PrefabUtility.InstantiatePrefab(replacer) as GameObject;
                    prefab.transform.position = pos;
                    prefab.transform.rotation = rot;

                    if (useSelectionScale)
                    {
                        prefab.transform.localScale = scale;
                    }

                    prefab.transform.parent = parent;
                    prefab.name = name;

                    newGOs.Add(prefab);

                    UnityEditor.SceneManagement.EditorSceneManager.MarkAllScenesDirty();
                }

                for (int i = 0; i < newGOs.Count; i++)
                {
                    Undo.RegisterCreatedObjectUndo(newGOs[i], "Undo created GameObject");
                }

            }
            else
            {
                Debug.Log("No item to replace with");
            }

            // if(GUI.changed)
            // {
            // 	// EditorUtility.SetDirty()
            // 	EditorUtility.SetDirty (target);

            // 	serializedObject.ApplyModifiedProperties ();

            // }
        }
    }

}