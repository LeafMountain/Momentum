using UnityEngine;

public class KillComponent : MonoBehaviour
{
    public void KillObject(GameObject objectToKill)
    {
        objectToKill?.GetComponent<HealthComponent>()?.Kill();
    }
}
