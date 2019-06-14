using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[DisallowMultipleComponent, AddComponentMenu("(つ♥v♥)つ/Movables/Rotate Object")]
public class RotateComponent : MonoBehaviour
{
    [SerializeField] Vector3 rotateTo;
    [SerializeField] float rotateSpeed;
    [SerializeField] GameObject objectToRotate;

    private bool _isRotating;

    void Update()
    {
        if (_isRotating)
        {
            objectToRotate.transform.rotation = Quaternion.Lerp(objectToRotate.transform.rotation, Quaternion.Euler(rotateTo), rotateSpeed * Time.deltaTime);

            float rotDif = Quaternion.Angle(objectToRotate.transform.rotation, Quaternion.Euler(rotateTo));
            if (rotDif <= 0.1f)
            {
                _isRotating = false;
            }
        }
    }

    public void MakeRotation()
    {
        _isRotating = true;
    }
}
