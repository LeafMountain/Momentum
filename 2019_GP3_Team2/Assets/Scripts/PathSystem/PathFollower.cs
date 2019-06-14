using System.Collections;
using System.Collections.Generic;
using UnityEditor;
using UnityEngine;
using UnityEngine.Events;

[RequireComponent(typeof(PathPoint), typeof(Rigidbody))]
[DisallowMultipleComponent, AddComponentMenu("(つ♥v♥)つ/Movables/Path Follower Movement")]

public class PathFollower : MonoBehaviour
{
    public enum Mode { Loop, PingPong, Once }

    public Mode mode;
    [Tooltip("How many seconds it takes to travel the whole path")] public float duration = 1;
    [Range(0, 1)] public float startOffset;
    public AnimationCurve moveCurve = new AnimationCurve(new Keyframe(0, 0, 1, 1), new Keyframe(1, 1, 1, 1));
    [SerializeField] private bool _showPath = true;

    [SerializeField] UnityEvent onAtStart;
    [SerializeField] UnityEvent onAtEnd;

    Rigidbody _rigidbody;
    float _direction = 1;
    float _gizmoDirection = 1;

    // Path
    PathPoint _path;
    float _pathProgress = 0;
    float _timeScale = 1;

    // Editor
    float _gizmoProgress;
    Vector3 _gizmoCurrentPosition;

    void Start()
    {
        _rigidbody = GetComponent<Rigidbody>();
        _path = GetComponent<PathPoint>();
        _pathProgress = startOffset;
    }

    void Reset()
    {
        _rigidbody = GetComponent<Rigidbody>();
        _rigidbody.isKinematic = true;
        _rigidbody.useGravity = false;
    }

    void FixedUpdate()
    {
        _pathProgress = UpdateProgress(_pathProgress, Time.deltaTime, ref _direction);
        _rigidbody.MovePosition(_path.GetPercentageAlongPath(moveCurve.Evaluate(_pathProgress)));

        if (0 -_pathProgress <= 0.01f)
        {
            onAtStart.Invoke();
        }
        else if (1 - _pathProgress <= 0.01)
        {
            onAtEnd.Invoke();
        }
    }

    float UpdateProgress(float progress, float deltaTime, ref float direction)
    {
        progress += (deltaTime * _timeScale * direction) / duration;

        if (mode == Mode.Loop)
        {
            _path.loop = true;
            progress %= 1;
        }
        else if (mode == Mode.PingPong)
        {
            _path.loop = false;
            progress = Mathf.Clamp01(progress);
            if (progress == 1 || progress == 0)
                direction *= -1;
        }
        else if (mode == Mode.Once)
        {
            _path.loop = false;
            progress = Mathf.Clamp01(progress);
        }

        return progress;
    }

    float _lastTime;
    float _deltaTime;

#if UNITY_EDITOR
    void OnDrawGizmos()
    {
        MeshFilter meshFilter = GetComponent<MeshFilter>();
        float deltaTime = EditorApplication.isPlaying ? Time.deltaTime : Time.fixedDeltaTime / 2;
        _deltaTime = Time.realtimeSinceStartup - _lastTime;
        _lastTime = Time.realtimeSinceStartup;

        _path = GetComponent<PathPoint>();
        Gizmos.color = Color.blue;

        if (!_showPath)
        {
            _gizmoCurrentPosition = _path.GetPercentageAlongPath(moveCurve.Evaluate(startOffset));
            _gizmoProgress = startOffset;
        }
        else
        {
            _gizmoProgress = UpdateProgress(_gizmoProgress, TimeHelper.gizmoDeltaTime, ref _gizmoDirection);
            _gizmoCurrentPosition = _path.GetPercentageAlongPath(moveCurve.Evaluate(_gizmoProgress));
            Gizmos.DrawSphere(_gizmoCurrentPosition, .3f);
        }

        if (meshFilter)
        {
            Gizmos.DrawWireMesh(meshFilter.sharedMesh, 0, _gizmoCurrentPosition, transform.rotation, transform.lossyScale);
            Gizmos.color = new Color(0, 0, 1, .7f);
            Gizmos.DrawMesh(meshFilter.sharedMesh, 0, _gizmoCurrentPosition, transform.rotation, transform.lossyScale);
        }
    }

    void OnDrawGizmosSelected()
    {
        if (!_path.editPath && !EditorApplication.isPlaying)
            _path.SetAnchor(transform.position);
    }
#endif

    public void SetTimeScale(float value)
    {
        _timeScale = value;
    }
}