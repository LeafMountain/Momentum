using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Platform : MonoBehaviour
{
    private Animator _platformDropper;

    private bool _fromLeft = true;
    private bool _fromRight;
    
    void Start()
    {
        _platformDropper = GetComponent<Animator>();
    }

    // Update is called once per frame
    void Update()
    {
        if (Input.GetKeyDown(KeyCode.P))
        {
            Drop();
        }

        if (Input.GetKeyDown(KeyCode.U))
        {
            UnDrop();
        }
    }

    public void Drop ()
    {
        if (_fromLeft == true)
        {
            _platformDropper.SetBool("isDropping", true);
            _fromLeft = false;
            Debug.Log("Drop");
        }

        if (_fromRight == true)
        {
            
            _fromRight = false;
            Debug.Log("Should do nothing");
        }
    }

    
    public void ResetBools ()
    {
        _fromLeft = true;
        _fromRight = false;
    }
    

    public void UnDrop ()
    {
        if (_fromRight == false)
        {
            _platformDropper.SetBool("isDropping", false);
            Debug.Log("Retracted Drop");
            _fromRight = true;
            _fromLeft = false;
        }

        if (_fromRight == true)
        {
            Debug.Log("No need to retract");
        }
        
        /*
        if (_fromRight == true)
        {
            _platformDropper.SetBool("isDropping", true);
            Debug.Log("Drop");
            _fromRight = false;
        }
        */
    }

}
