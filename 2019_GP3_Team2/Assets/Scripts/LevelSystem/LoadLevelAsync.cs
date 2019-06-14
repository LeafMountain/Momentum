using UnityEditor;
using UnityEngine;
using UnityEngine.SceneManagement;

public class LoadLevelAsync : MonoBehaviour
{
    public string sceneToLoad;
    public string sceneToUnload;

    [ContextMenu("Load Level")]
    public void LoadLevel()
    {
        SceneManager.LoadSceneAsync(sceneToLoad, LoadSceneMode.Additive);
    }

    [ContextMenu("Unload Level")]
    public void UnloadLevel()
    {
        SceneManager.UnloadSceneAsync(sceneToUnload);
    }
}
