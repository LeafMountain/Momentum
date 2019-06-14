using System.Collections;
using Unity.Collections;
using UnityEditor;
using UnityEngine;
using UnityEngine.Events;

[RequireComponent(typeof(CharacterController))]
public class MovementComponent : MonoBehaviour
{
    #region Serialized variables : Movement
    [Header("Movement")]
    [SerializeField] private float _speed = 5f;
    [SerializeField, Range(0, 2)] private float _airSpeedMultiplier = 1;
    [SerializeField] private float _jumpHeight = 1f;
    [SerializeField] private FloatVariable _rotationSpeed;
    [ReadOnly] public float gravity = -12f;
    [Tooltip("In degrees"), SerializeField] private float _slopeLimit = 45;
    #endregion

    [Header("Input")]
    [Tooltip("Data that determines the input of player actions")]
    [SerializeField] private InputProfile _inputProfile;

    CharacterController _controller;
    GameObject ground;
    Vector3 _fixedGroundDelta;
    Vector3 _lastGroundPosition;

    public float groundedCheckDistance = .1f;
    [Range(0, 1)]
    public float resistance = .4f;
    public float maxHorizontalSpeed = 15f;

    Vector3 velocity;

    [HideInInspector]
    public bool disableMovement;

    Vector3 realVelocity;
    Vector3 lastPosition;

    Vector3 feetPosition { get => transform.position + Vector3.down * (GetComponent<CharacterController>().height / 2); }
    // ye
    [Header("Events")]
    [SerializeField] UnityEvent OnJump;

    [System.Serializable]
    public struct LandedVelocity
    {
        [Tooltip("The minimum velocity required on the y-axis for the OnLanded Event to be called")]
        public float minLandedVelocity;
        public UnityEvent OnLanded;
    }

    [SerializeField] LandedVelocity[] landingVelocityEvents;

    private bool lastGrounded;

    private void Start()
    {
        _controller = GetComponent<CharacterController>();
        lastPosition = transform.position;
    }

    private void Update()
    {
        realVelocity = transform.position - lastPosition;
        lastPosition = transform.position;

        // Apply gravity
        // velocity.y += Time.deltaTime * gravity;

        Vector3 myGravity = Vector3.up * gravity * Time.deltaTime;

        if (!IsGrounded())
        {
            // Project gravity
            Vector3 rayOrigin = transform.position + _controller.center + Vector3.down * ((_controller.height / 2) - _controller.radius);
            RaycastHit hit;
            if (Physics.SphereCast(rayOrigin, _controller.radius, Vector3.down, out hit, groundedCheckDistance))
            {
                myGravity = Vector3.ProjectOnPlane(myGravity, hit.normal);

                // Limit velocity if obstructed
                Ray velocityRay = new Ray(transform.position, velocity.normalized);
                RaycastHit velocityHit;
                if (Physics.Raycast(velocityRay, out velocityHit, velocity.magnitude) && hit.transform == velocityHit.transform)
                {
                    velocity = Vector3.ClampMagnitude(velocity, velocityHit.distance);
                }
                // else
                //     ggravity *= 5;
                Debug.DrawLine(transform.position, transform.position + velocityRay.direction * velocityHit.distance, Color.green);
            }


        }
        Debug.DrawLine(transform.position, transform.position + velocity, Color.magenta);

        velocity += myGravity;

        if (!disableMovement)
        {
            Vector3 horizontalVelocity = new Vector3(velocity.x, 0, velocity.z);
            horizontalVelocity = Vector3.ClampMagnitude(horizontalVelocity, maxHorizontalSpeed);
            velocity.x = horizontalVelocity.x;
            velocity.z = horizontalVelocity.z;
        }

        // Move 
        _controller.Move(velocity * Time.deltaTime);

        // Add resistance when grounded to slow down
        if (IsGrounded())
        {
            if (lastGrounded == false)
            {
                if (landingVelocityEvents != null)
                {
                    if (landingVelocityEvents.Length >= 1)
                    {
                        for (int i = 0; i < landingVelocityEvents.Length; i++)
                        {
                            if (-velocity.y >= landingVelocityEvents[i].minLandedVelocity)
                            {
                                if (i + 1 < landingVelocityEvents.Length)
                                {
                                    if (-velocity.y <= landingVelocityEvents[i + 1].minLandedVelocity)
                                        landingVelocityEvents[i].OnLanded.Invoke();
                                }
                                else
                                {
                                    landingVelocityEvents[i].OnLanded.Invoke();
                                }
                            }
                        }
                    }
                }
                /*if (velocity.y <= -minLandedVelocity)
                {
                    OnLanded.Invoke();
                }*/
                lastGrounded = true;
            }

            velocity.y = 0;
            velocity.x *= 1 - resistance;
            velocity.z *= 1 - resistance;
            disableMovement = false;
        }
        else
        {
            lastGrounded = false;
        }


        // velocity.y = velocity.y < gravity * 3 ? gravity * 3 : velocity.y;

        // Read input
        Move(_inputProfile.GetInputVector());
        Rotate(_inputProfile.GetLookVector().x * Time.timeScale);
        if (_inputProfile.GetJumpButtonDown()) StartCoroutine(Jump());


        // Debug.Log(IsGrounded());
    }

    void LateUpdate()
    {
        FollowGround();
    }

    private void FollowGround()
    {
        _fixedGroundDelta = Vector3.zero;

        Vector3 rayOrigin = transform.position + _controller.center + Vector3.down * ((_controller.height / 2) - _controller.radius);
        RaycastHit hit;
        if (Physics.SphereCast(rayOrigin, _controller.radius, Vector3.down, out hit, groundedCheckDistance))
        {
            float angleFloor = Vector3.Angle(Vector3.up, hit.normal);
            if (angleFloor < _slopeLimit)
            {
                if (ground != hit.transform.gameObject)
                {
                    ground = hit.transform?.gameObject;
                    if (ground)
                        _lastGroundPosition = ground.transform.position;
                }

                _fixedGroundDelta = ground.transform.position - _lastGroundPosition;
                _lastGroundPosition = ground.transform.position;

                if (_fixedGroundDelta != Vector3.zero && Vector3.Angle(_fixedGroundDelta.normalized, velocity) < 170)
                    _controller.Move(_fixedGroundDelta);
            }
        }
    }

    private void Rotate(float yaw)
    {
        Vector3 rotation = transform.rotation.eulerAngles;
        rotation.y += yaw * _rotationSpeed.value;
        transform.rotation = Quaternion.Euler(rotation);
    }

    private void Move(Vector2 movementDirection) => Move(movementDirection.x, movementDirection.y);
    private void Move(float horizontal, float vertical)
    {
        if (disableMovement) return;

        float speedMultiplier = IsGrounded() ? 1 : _airSpeedMultiplier;
        Vector3 inputMoveDirection = transform.TransformDirection(new Vector3(horizontal, 0, vertical).normalized);
        Vector3 horizontalVelocity = new Vector3(velocity.x, 0, velocity.z);
        Vector3 moveForce = Vector3.zero;


        if (horizontalVelocity.magnitude < _speed)
        {
            moveForce = inputMoveDirection * (_speed * speedMultiplier);
            moveForce = Vector3.ClampMagnitude(moveForce, _speed - horizontalVelocity.magnitude);
        }
        else if (Vector3.Angle(horizontalVelocity, inputMoveDirection) > 44f)
        {
            moveForce = inputMoveDirection * (_speed * speedMultiplier);
        }

        // Clamp move force
        if (!IsGrounded())
        {
            RaycastHit hit;
            if (Physics.Raycast(feetPosition, moveForce.normalized, out hit, _controller.radius + 2f))
            {
                moveForce = Vector3.ClampMagnitude(moveForce, hit.distance);
                moveForce = Vector3.ProjectOnPlane(moveForce, hit.normal);
                if (!IsGrounded()) moveForce.y = 0;
            }
            Debug.DrawRay(feetPosition, transform.position + moveForce, Color.red);
        }

        AddForce(moveForce);
    }

    bool jumping = false;
    private IEnumerator Jump()
    {

        if (IsGrounded() && !jumping)
        {
            jumping = true;

            float jumpVelocity = Mathf.Sqrt(-2 * gravity * _jumpHeight);
            velocity.y = 0;
            AddForce(Vector3.up * jumpVelocity + Vector3.up * Mathf.Clamp(_fixedGroundDelta.y, 0, Mathf.Infinity));
            OnJump.Invoke();
            yield return new WaitForSeconds(.2f);

            jumping = false;
        }
    }

    public void SetVelocity(Vector3 newVelocity)
    {
        velocity = newVelocity;
    }

    public void AddForce(Vector3 force)
    {
        velocity += force + _fixedGroundDelta;
    }

    public bool IsGrounded()
    {
        if (jumping) return false;

        bool grounded = false;
        Vector3 rayOrigin = transform.position + _controller.center + Vector3.down * ((_controller.height / 2) - _controller.radius);
        RaycastHit hit;
        if (Physics.SphereCast(rayOrigin, _controller.radius, Vector3.down, out hit, groundedCheckDistance))
        {
            float angleFloor = Vector3.Angle(Vector3.up, hit.normal);
            grounded = (angleFloor < _slopeLimit);
        }

        return grounded;
    }

    public void SetPosition(Vector3 position)
    {
        velocity = Vector3.zero;
        transform.position = position;
    }

#if UNITY_EDITOR

    void OnDrawGizmos()
    {
        _controller = GetComponent<CharacterController>();
        Gizmos.DrawCube(feetPosition, new Vector3(_controller.radius, .1f, _controller.radius));
        // _controller = GetComponent<CharacterController>();
        // Gizmos.DrawSphere(transform.position - (transform.up * (((_controller.height / 2) - _controller.radius * .8f) + groundedCheckDistance)), _controller.radius);

        // Vector3 center = transform.position - velocity;
        // Vector3 topLeft = transform.TransformDirection(new Vector3(-1, 0, 1)) * _speed + center;
        // Vector3 topRight = transform.TransformDirection(new Vector3(1, 0, 1)) * _speed + center;
        // Vector3 bottomRight = transform.TransformDirection(new Vector3(1, 0, -1)) * _speed + center;
        // Vector3 bottomLeft = transform.TransformDirection(new Vector3(-1, 0, -1)) * _speed + center;

        // Debug.DrawLine(topLeft, topRight);
        // Debug.DrawLine(topRight, bottomRight);
        // Debug.DrawLine(bottomRight, bottomLeft);
        // Debug.DrawLine(bottomLeft, topLeft);

        // Gizmos.DrawWireSphere(center, _speed);
    }

#endif
}