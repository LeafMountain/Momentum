using UnityEngine;
using UnityEngine.Events;

public class CheckIdleComponent : MonoBehaviour
{
    [SerializeField] private InputProfile _inputProfile;

    [SerializeField] private float _timeUntilIdle = 20;
    [SerializeField] private UnityEvent _onIdle;

    private float _timer;
    
    void Start()
    {
        _timer = 0;
        if (!_inputProfile)
        {
            Debug.LogError("You have no input profile to " + gameObject.name);
            return;
        }
    }

    void Update()
    {
        /* **Remove if we want to add "On Standing Still" AI Event**
        
        if (_inputProfile.GetInputVector() == Vector2.zero)
        {
            _timer += Time.deltaTime;
            if (_timer > _timeUntilIdle)
            {
                _timer = 0;
                _onIdle.Invoke();
            }
        }
        else
            _timer = 0;
        */
    }
}
