using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ShootComponentChalle : MonoBehaviour
{
    [Header("Input")]
    [Tooltip("Data that determines the input of player actions")]
    [SerializeField] private InputProfile _playerInput;

    [SerializeField] private float _shootLength = 1000.0f;
    [SerializeField] private float _aimAssistRadius = 20.0f;



    public float speedMultiplier = 2;
    public float slowMultiplier = .5f;


    //privates
    private Camera fpsCam;
    private LineRenderer lineRenderer;

    //publics
    public Transform gunEnd;
    public Material matSlow;
    public Material matFast;


    private void Start()
    {
        lineRenderer = GetComponent<LineRenderer>();
        fpsCam = GetComponent<Camera>();
    }



    private void Update()
    {
        if (_playerInput.GetPrimaryFireButton())
            Fire(speedMultiplier);


        if (_playerInput.GetSecondaryFireButton())
            Fire(slowMultiplier);


    }

    private void Fire(float value)
    {
        DrawLine(transform.forward * _shootLength);

        RaycastHit hit;
        if (Physics.Raycast(transform.position, transform.TransformDirection(Vector3.forward) * _shootLength, out hit))
        {
            Debug.Log("Hit: " + hit.transform.gameObject.name);
            // ITimeAdjustable timeAdjustable = hit.transform.GetComponent<ITimeAdjustable>();
            // if (timeAdjustable != null) timeAdjustable.OnHit(value);
        }

        //GameObject _closeObject = GetObjectClosestToAim();
    }


    // Doesn't work yet DON'T USE
    GameObject GetObjectClosestToAim()
    {
        RaycastHit[] hit = Physics.SphereCastAll(transform.position, _aimAssistRadius, transform.forward, 0);
        float _closestDot = -2f;
        int _closestDotIndex = 0;

        for (int i = 0; i < hit.Length; i++)
        {

            if (hit[i].transform.gameObject == this.gameObject)
                continue;

            Vector3 _dif = hit[i].transform.position - transform.position;
            //Debug.DrawLine(transform.position, transform.position + _dif, Color.red);

            float _newDot = Vector3.Dot(transform.forward, _dif);
            if (_newDot > _closestDot)
            {
                _closestDot = _newDot;
                _closestDotIndex = i;
                //Debug.Log("Closest: " + hit[i].transform.gameObject);
            }

            //hit[i].transform.gameObject.GetComponent<Renderer>().material.color = Color.black;
        }

        //hit[_closestDotIndex].transform.gameObject.GetComponent<Renderer>().material.color = Color.red;

        return hit[_closestDotIndex].transform.gameObject;
    }

    private void OnDrawGizmos()
    {
        //Gizmos.color = Color.green;
        //Gizmos.DrawLine(transform.position, transform.position + transform.forward * _shootLength);


        //Gizmos.DrawWireSphere(transform.position, _aimAssistRadius);

        //Debug.DrawLine(transform.position, transform.position + transform.forward * _shootLength, Color.green);
    }

    void DrawLine(Vector3 endPosition)
    {
        lineRenderer.enabled = true;

        lineRenderer.material = matSlow;

        lineRenderer.SetPosition(0, gunEnd.position);

        lineRenderer.SetPosition(1, endPosition);

    }
}
