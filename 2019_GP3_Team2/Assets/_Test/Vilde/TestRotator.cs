using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TestRotator : MonoBehaviour
{

    public Vector3 axis;
    public float _timeScale = 1.0f;
    public int snapFrequency;
    public float _rotationSpeed = 20.0f;
    public int eventIndex = 0;

    public int closestIndex = 0;

    public Vector3 checkVec;

    public Vector3[] snapPositions;

    void Start()
    {
        snapPositions = new Vector3[snapFrequency];

        checkVec = Vector3.Cross(transform.up, axis);

        for (int i = 0; i < snapFrequency; i++)
        {
            snapPositions[i] = GetPointOnCircle(2, i);
        }

    }

    void Update()
    {
        if (axis == transform.up)
        {
            checkVec = Vector3.Cross(transform.forward, axis);
        }
        else
        {
            checkVec = Vector3.Cross(transform.up, axis);
        }

        DebugHelper.DrawArrow(transform.position, checkVec, Color.blue, 2.5f, .1f);


        if (_timeScale < 0.01f)
        {
            /*Quaternion newRot = Quaternion.LookRotation(snapPositions[closestIndex]);
            Quaternion newerRot = Quaternion.Lerp(transform.rotation, newRot, Time.deltaTime);
            Quaternion newererRot = Quaternion.Euler(newerRot * axis);
            transform.rotation = newRot;*/

            Vector3 rotation = transform.rotation.eulerAngles;
            float snapAngle = Vector3.Angle(snapPositions[closestIndex], transform.up);
            rotation.x = Mathf.Round(rotation.x / snapAngle) * snapAngle;
            rotation.y = Mathf.Round(rotation.y / snapAngle) * snapAngle;
            rotation.z = Mathf.Round(rotation.z / snapAngle) * snapAngle;

            Vector3 tmp = new Vector3(Mathf.Ceil(axis.x), Mathf.Ceil(axis.x), Mathf.Ceil(axis.x));

            Vector3 newRot = new Vector3(rotation.x * tmp.x, rotation.y * tmp.y, rotation.z * tmp.z);

            //transform.eulerAngles = Vector3.Lerp(transform.eulerAngles, newRot, Time.deltaTime);

            print(tmp);

        }
        else
        {
            float angle = _rotationSpeed * _timeScale * Time.deltaTime;
            transform.Rotate(axis, angle);
        }

    }

    public void SetTimeScale(float value)
    {
        _timeScale = value;
        if (_timeScale < 0.01f)
        {
            float closestAngle = Mathf.Infinity;

            for (int i = 0; i < snapFrequency; i++)
            {
                float angle = Vector3.Angle(snapPositions[i], checkVec);

                if (angle < closestAngle)
                {
                    closestAngle = angle;
                    closestIndex = i;
                }


            }

            //transform.eulerAngles = Vector3.Lerp(transform.eulerAngles, snapPositions[closestIndex], Time.deltaTime);


            DebugHelper.DrawArrow(transform.position, snapPositions[closestIndex], Color.red, 2, .1f);


            if (closestIndex == eventIndex)
            {
                //OnEventIndex.Invoke();
            }
        }
    }

    void OnDrawGizmos()
    {
        for (int i = 0; i < snapFrequency; i++)
        {
            Vector3 newPos = GetPointOnCircle(2, i);

            DebugHelper.DrawArrow(transform.position, newPos, Color.green, 1, .1f);
        }

        if (snapPositions.Length > 0)
        {
            DebugHelper.DrawArrow(transform.position, snapPositions[eventIndex], Color.yellow, 1.2f, .1f);
        }

    }

    public Vector3 GetPointOnCircle(float radius, float index)
    {
        float theta = (360 / snapFrequency) * index;
        Vector3 tmp = (axis.normalized - Vector3.one) * -1;
        return Quaternion.AngleAxis(theta, axis) * tmp;
    }
}
