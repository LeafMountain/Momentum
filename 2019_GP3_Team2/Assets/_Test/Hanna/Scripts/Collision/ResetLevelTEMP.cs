using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class ResetLevelTEMP : MonoBehaviour
{
    public void RestartScene() => SceneManager.LoadScene(SceneManager.GetActiveScene().name);

    private void OnTriggerEnter(Collider other)
    {


        if (other.gameObject.tag == "Player")
        {
            Debug.Log("Reset level on death.");
            

        }
    }



}
