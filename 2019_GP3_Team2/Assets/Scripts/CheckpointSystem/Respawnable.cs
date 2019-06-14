using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;

public class Respawnable : MonoBehaviour
{
    public UnityEvent OnRespawn;

    Vector3 spawnPoint;
    Quaternion spawnRotation;

    public void SetSpawnPosition(Vector3 position) => spawnPoint = position;
    public void SetSpawnRotation(Quaternion rotation) => spawnRotation = rotation;

    public void SetSpawnTransform(Transform transform) => SetSpawnTransform(transform.position, transform.rotation);
    public void SetSpawnTransform(Vector3 position, Quaternion rotation)
    {
        SetSpawnPosition(position);
        SetSpawnRotation(rotation);
    }

    public void Respawn()
    {
        MovementComponent move = GetComponent<MovementComponent>();
        move.enabled = false;
        move.SetVelocity(Vector3.zero);
        transform.position = spawnPoint;
        transform.rotation = spawnRotation;
        StartCoroutine(EnableMovement());
    }

    IEnumerator EnableMovement()
    {
        yield return new WaitForSeconds(.1f);
        GetComponent<MovementComponent>().enabled = true;
        OnRespawn.Invoke();
    }

    void Start()
    {
        SetSpawnTransform(transform);
    }
}
