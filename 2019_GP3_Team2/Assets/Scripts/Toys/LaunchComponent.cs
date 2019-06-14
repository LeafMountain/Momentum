using System.Collections;
using UnityEngine;
using UnityEngine.Events;

[AddComponentMenu("(つ♥v♥)つ/Toys/Launch Component")]
public class LaunchComponent : MonoBehaviour
{
    public Vector3 target;
    public float height = 20;
    [HideInInspector] public float _gravity = -18;

    public bool drawPath;
    public GameObject directionArrowsObject;
    public bool canLaunch = true;

    public UnityEvent onLaunch;

    //LaunchData lastLaunch;
    Vector3 lastLaunchedObjectPos;

    public void ResetTargetPosition()
    {
        target = transform.position + new Vector3(2, 0, 0);
    }

    void Start()
    {
        UpdateDirectionArrow();
    }

    void Update()
    {
        if (drawPath)
        {
            LaunchData launchData = CalculateLaunchData(transform.position, _gravity);
            // DrawPath(transform.position, launchData, Color.green);
            DebugHelper.DrawArrow(target, Vector3.down, Color.red, Color.red, 0, 1);
        }

        //if (lastLaunchedObjectPos != Vector3.zero)
        //{
        //LaunchData launchData = CalculateLaunchData(lastLaunchedObjectPos, _gravity);
        // DrawPath(lastLaunchedObjectPos, launchData, Color.red);
        //DebugHelper.DrawArrow(target, Vector3.down, Color.red, Color.red, 0, 1);
        //}
    }

    bool eventOnCooldown;
    IEnumerator TriggerLaunchEvent()
    {
        eventOnCooldown = true;
        onLaunch.Invoke();
        yield return new WaitForSeconds(.1f);
        eventOnCooldown = false;

    }

    public void Launch(GameObject objectToLaunch)
    {
        if (canLaunch == false)
            return;

        if (!eventOnCooldown)
            StartCoroutine(TriggerLaunchEvent());

        Vector3 positionToLaunch = Vector3.zero;

        if (objectToLaunch)
        {
            positionToLaunch = objectToLaunch.GetComponent<Collider>().bounds.min;
        }

        if (objectToLaunch?.GetComponent<MovementComponent>())
        {
            MovementComponent movComp = objectToLaunch.GetComponent<MovementComponent>();
            _gravity = movComp.gravity;
            LaunchData launchData = CalculateLaunchData(positionToLaunch, movComp.gravity);
            movComp.disableMovement = true;
            movComp.SetVelocity(launchData.initialVelocity);
            // movComp.transform.position = transform.position;
            lastLaunchedObjectPos = positionToLaunch;
        }
        else if (objectToLaunch?.GetComponent<Rigidbody>())
        {
            Rigidbody rb = objectToLaunch.GetComponent<Rigidbody>();
            rb.useGravity = true;
            _gravity = Physics.gravity.y;
            LaunchData launchData = CalculateLaunchData(positionToLaunch, Physics.gravity.y);
            rb.velocity = launchData.initialVelocity;
            lastLaunchedObjectPos = positionToLaunch;
        }
    }

    LaunchData CalculateLaunchData(Vector3 from, float gravity)
    {
        float displacementY = target.y - from.y;
        Vector3 displacementXZ = new Vector3(target.x - from.x, 0, target.z - from.z);
        float time = Mathf.Sqrt(-2 * height / gravity) + Mathf.Sqrt(2 * (displacementY - height) / gravity);
        Vector3 velocityY = Vector3.up * Mathf.Sqrt(-2 * gravity * height);
        Vector3 velocityXZ = displacementXZ / time;

        return new LaunchData(velocityXZ + velocityY * -Mathf.Sign(gravity), time);

        //return lastLaunch;
    }

    // void DrawPath(Vector3 from, LaunchData launchData, Color color)
    // {
    //     Gizmos.color = color;
    //     Vector3 previousDrawPoint = from;

    //     int resolution = 10;
    //     for (int i = 1; i <= resolution; i++)
    //     {
    //         float simulationTime = i / (float)resolution * launchData.timeToTarget;
    //         Vector3 displacement = launchData.initialVelocity * simulationTime + Vector3.up * _gravity * simulationTime * simulationTime / 2f;
    //         Vector3 drawPoint = from + displacement;

    //         // if (i == resolution)
    //         //     DebugHelper.DrawArrow(previousDrawPoint, drawPoint, Color.red, .8f);
    //         // else
    //         Gizmos.DrawLine(previousDrawPoint, drawPoint);

    //         previousDrawPoint = drawPoint;
    //     }
    // }

    struct LaunchData
    {
        public readonly Vector3 initialVelocity;
        public readonly float timeToTarget;

        public LaunchData(Vector3 initialVelocity, float timeToTarget)
        {
            this.initialVelocity = initialVelocity;
            this.timeToTarget = timeToTarget;
        }
    }

    /// <summary>
    /// Set the state of the launchpad
    /// </summary>
    /// <param name="value">Activated if anything except 0</param>
    public void SetActiveState(float value)
    {
        canLaunch = value == 0 ? false : true;
    }

    [ExecuteInEditMode]
    void OnValidate()
    {
        height = Mathf.Clamp(height, target.y - transform.position.y, Mathf.Infinity);
    }

    void OnDrawGizmos()
    {
        if (drawPath)
        {
            LaunchData launchData = CalculateLaunchData(transform.position, _gravity);
            // DrawPath(transform.position, launchData, Color.green);
            Gizmos.color = Color.green;
            Vector3 previousDrawPoint = transform.position;

            int resolution = 10;
            for (int i = 1; i <= resolution; i++)
            {
                float simulationTime = i / (float)resolution * launchData.timeToTarget;
                Vector3 displacement = launchData.initialVelocity * simulationTime + Vector3.up * _gravity * simulationTime * simulationTime / 2f;
                Vector3 drawPoint = transform.position + displacement;

                // if (i == resolution)
                //     DebugHelper.DrawArrow(previousDrawPoint, drawPoint, Color.red, .8f);
                // else
                Gizmos.DrawLine(previousDrawPoint, drawPoint);

                previousDrawPoint = drawPoint;
            }
        }
    }

    public void UpdateDirectionArrow()
    {
        LaunchData launchData = CalculateLaunchData(transform.position, _gravity);

        float simulationTime = 1 / 10f * launchData.timeToTarget;
        Vector3 displacement = launchData.initialVelocity * simulationTime + Vector3.up * _gravity * simulationTime * simulationTime / 2f;
        Vector3 rotatePoint = transform.position + displacement;

        directionArrowsObject.transform.LookAt(rotatePoint);
        //transform.rotation = Quaternion.RotateTowards(rotatePoint);//Quaternion.Lerp(transform.rotation, Quaternion.Euler(rotatePoint), rotateSpeed * Time.deltaTime);
    }
}
