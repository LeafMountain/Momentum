// This Script is attached to the projectile

using UnityEngine;
using System.Collections;

public class ProjectileScript : MonoBehaviour
{
    public delegate void ProjectileEvent(GameObject go);
    public ProjectileEvent OnHit;

    public GameObject Explosion;
    float speed = 1.0f;

    Vector3 _direction;
    Transform _target;
    Collider instagator;

    void FixedUpdate()
    {
        // Check if collided
        RaycastHit hit;
        if (Physics.Raycast(transform.position, _direction * speed, out hit, speed * Time.fixedDeltaTime) && hit.collider != instagator)
        {
            OnHit?.Invoke(hit.transform.gameObject);
            Destroy(gameObject);
        }

        Vector3 moveDirection = _direction * speed;

        if (_target)
        {
            moveDirection = _target.position - transform.position;

            float distance = moveDirection.magnitude;
            moveDirection.Normalize();
            moveDirection *= speed;
            moveDirection *= Time.deltaTime;
            moveDirection = Vector3.ClampMagnitude(moveDirection, distance);
            transform.Translate(moveDirection);

            if (distance < .2f)
                Destroy(gameObject);
        }
        else
        {
            moveDirection *= Time.fixedDeltaTime;
            transform.Translate(moveDirection);
        }

    }

    void OnDisable()
    {
        GameObject ThisExplosion = Instantiate(Explosion, gameObject.transform.position, gameObject.transform.rotation) as GameObject;
    }

    public void SetInstagator(Collider instagator)
    {
        this.instagator = instagator;
    }

    public void SetDirection(Vector3 direction)
    {
        this._direction = direction.normalized;
    }

    public void SetSpeed(float speed)
    {
        this.speed = speed;
    }

    public void SetTarget(Transform target)
    {
        this._target = target;
    }
}
