using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.AI;

[DisallowMultipleComponent, AddComponentMenu("(つ♥v♥)つ/Movables/NavMesh Path Movement")]
[RequireComponent(typeof(NavMeshAgent))]
[RequireComponent(typeof(PathPoint))]
public class NavMeshWalkerComponent : MonoBehaviour
{
    [Header("Attributes")]
    [Range(0.01f, 10)]
    [SerializeField] private float _speed = 5f;

    private PathPoint _pathPoint;
    private NavMeshAgent _agent;

    private int _currentPathPointIndex = 0;
    private float _nextPointDistance = 0.1f;
    private float _timeScale = 1;

    public void SetTimeScale(float value)
    {
        _timeScale = value;
    }

    public void ResetTimeScale()
    {
        _timeScale = 1;
    }

    private void Awake()
    {
        _agent = GetComponent<NavMeshAgent>();

        if (_agent == null)
            Debug.LogError("No NavMeshAgent on " + gameObject.name);
    }

    private void Start()
    {
        _pathPoint = GetComponent<PathPoint>();
        if (_pathPoint == null)
            Debug.LogError("The " + _pathPoint.name + " is null on " + gameObject.name);

        _agent.SetDestination(_pathPoint.points[_currentPathPointIndex]);
    }

    private void Update()
    {
        _agent.speed = _speed * _timeScale;

        if (!_agent.pathPending && _agent.remainingDistance <= _nextPointDistance)
            _currentPathPointIndex = (_currentPathPointIndex + 1) % _pathPoint.points.Length;

        _agent.SetDestination(_pathPoint.points[_currentPathPointIndex]);
    }
}

