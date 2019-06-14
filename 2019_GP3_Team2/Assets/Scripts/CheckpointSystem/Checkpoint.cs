using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[RequireComponent(typeof(TriggerArea))]
public class Checkpoint : MonoBehaviour
{
    public Vector3 spawnOffset;

    TriggerArea trigger;
    Vector3 spawnPosition { get => transform.position + spawnOffset; }

    void Start()
    {
        trigger = GetComponent<TriggerArea>();
        trigger.TriggerEnter.AddListener(SetCheckpoint);
    }

    public void SetCheckpoint(GameObject go)
    {
        go?.GetComponent<Respawnable>()?.SetSpawnTransform(transform);
    }

    void OnDrawGizmos()
    {
        Gizmos.DrawSphere(spawnPosition, .5f);
    }
}
