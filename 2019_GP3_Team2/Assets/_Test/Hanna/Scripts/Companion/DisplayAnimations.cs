using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DisplayAnimations : MonoBehaviour
{
    private Animator _displayControllerAnimator;

    private bool _isGoingUp = false;
    private bool _isGoingDown = false;
    private bool _isDisplayMovementActive = false;

    


    void Start()
    {
        _displayControllerAnimator = GetComponent<Animator>();
    }

    
    void Update()
    {
        if (Input.GetKeyDown(KeyCode.F) && !_isGoingUp)
        {
            _isDisplayMovementActive = true;
            GoUp();
        }

        else if (Input.GetKeyDown(KeyCode.F) && !_isGoingDown)
        {
            _isDisplayMovementActive = false;
            GoDown();
        }
    }

    public void GoUp ()
    {
        _displayControllerAnimator.SetBool("isGoingUp", true);
        _displayControllerAnimator.SetBool("isGoingDown", false);
        _isGoingUp = true;
        _isGoingDown = false;

    }

    public void GoDown ()
    {
        _displayControllerAnimator.SetBool("isGoingDown", true);
        _displayControllerAnimator.SetBool("isGoingUp", false);

        _isGoingDown = true;
        _isGoingUp = false;
    }

}
