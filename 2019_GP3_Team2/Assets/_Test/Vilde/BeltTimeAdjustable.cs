using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;

public class BeltTimeAdjustable : MonoBehaviour
{
    [SerializeField] private float _timeScale = 1.0f;

    private float _beltSpeed = 1.0f;

    private void OnCollisionStay(Collision collision)
    {
        Rigidbody _otherRb = collision.gameObject.GetComponent<Rigidbody>();


        if (_otherRb)
        {
            collision.gameObject.GetComponent<Rigidbody>().AddForce(transform.forward * _timeScale, ForceMode.Impulse); //velocity += transform.forward * _beltSpeed;
        }
    }

    public void SetTimeScale(float value)
    {
        _timeScale = value;

        GetComponent<Renderer>().sharedMaterial.SetFloat("_BeltSpeed", value);
    }

    private void OnDrawGizmos()
    {
        DebugHelper.DrawArrow(transform.position, transform.forward, 3.0f, 0.5f);
    }
}
