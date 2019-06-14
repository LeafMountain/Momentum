using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CameraRotator : MonoBehaviour
{
    #region serialized variables : Rotation

    // [Tooltip("The amount of lerp when the player rotates from one point to another")]
    // [Range(0f, 1f)]
    // [SerializeField] private float _lerpAmount = 0f;

    [Tooltip("Rotation speed on X axis")]
    [SerializeField] private FloatVariable _sensitivityX;

    [Tooltip("Restriction on X axis")]
    [SerializeField] private MinMaxFloat _xAngle = new MinMaxFloat(-80, 80);

    #endregion

    private float _rotationX = 0f;
    // private float _velocity;

    [Tooltip("Data that determines the input of player actions")]
    [SerializeField] private InputProfile _playerInput;

    void Update()
    {
        Rotation(_playerInput.GetLookVector() * Time.timeScale);
    }

    private void Rotation(Vector2 rotation) => Rotation(rotation.x, rotation.y);

    private void Rotation(float yaw, float pitch)
    {
        Vector3 rotation = transform.rotation.eulerAngles;
        _rotationX += _sensitivityX.value * pitch;
        _rotationX = Mathf.Clamp(_rotationX, _xAngle.Min, _xAngle.Max);
        rotation.x = -_rotationX;
        transform.rotation = Quaternion.Euler(rotation);
    }
}
