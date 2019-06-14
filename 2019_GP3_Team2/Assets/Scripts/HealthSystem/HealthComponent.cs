using UnityEngine;
using UnityEngine.Events;

public class HealthComponent : MonoBehaviour
{
    [SerializeField] UnityEvent _onDeath;
    public bool isDead
    { get; private set; }
     
    public void Kill()
    {
        isDead = true;
        _onDeath.Invoke();
    }

    public void Revive()
    {
        isDead = false;
    }
}
