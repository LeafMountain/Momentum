using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Tutorial_CheckJump : MonoBehaviour
{
    public GameObject jumpTextObject;
    public GameObject blockCollider;

    private void Awake()
    {
        jumpTextObject.SetActive(false);
    }


    void Update()
    {
        if (Input.GetKeyDown(KeyCode.Space))
        {
            jumpTextObject.SetActive(true);
            blockCollider.SetActive(false);
        }
    }
}
