using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FallingFloorPiece_AnimScript : MonoBehaviour
{
    private Animator _fallingAnimator;
   
    private bool _isFalling = false;


    
    void Start()
    {
        _fallingAnimator = GetComponentInChildren<Animator>();
    }

    // Update is called once per frame
    void Update()
    {
        if (Input.GetKeyDown(KeyCode.F))
        {
            FallingDebris();
            _isFalling = true;
        }
    }

    public void FallingDebris()
    {
        _fallingAnimator.SetBool("isFalling", true);
    }
}
