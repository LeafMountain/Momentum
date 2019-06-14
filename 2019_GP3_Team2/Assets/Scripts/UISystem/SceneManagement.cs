using UnityEngine;
using UnityEngine.SceneManagement;

public class SceneManagement : MonoBehaviour
{
    public void LoadScene(string name) => SceneManager.LoadScene(name);

    public void LoadSceneAdditive(string name) => SceneManager.LoadScene(name, LoadSceneMode.Additive);

    public void LoadSceneAsyncAdditive(string name) => SceneManager.LoadSceneAsync(name, LoadSceneMode.Additive);

    public void SetSceneActive(string name) => SceneManager.SetActiveScene(SceneManager.GetSceneByName(name));

    public void RestartScene() => SceneManager.LoadScene(SceneManager.GetActiveScene().name);

    public void ExitGame() => Application.Quit();
}
