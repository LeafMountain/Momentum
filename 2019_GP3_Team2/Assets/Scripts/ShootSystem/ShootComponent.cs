using System.Collections;
using System.Collections.Generic;
using UnityEditor;
using UnityEngine;
using UnityEngine.Events;

// [System.Serializable]
// public class UnityEventShootHit : UnityEvent<ShootHit> { }

[DisallowMultipleComponent, AddComponentMenu("(つ♥v♥)つ/Useables/Shoot")]
public class ShootComponent : MonoBehaviour
{
    [Header("Input")]
    [Tooltip("Data that determines the input of player actions")]
    [SerializeField] private InputProfile _inputProfile;

    //publics
    public Transform shootOrigin;
    public Transform vfxOrigin;

    // New shit
    public GameObject insertProjectilePrefab;
    public GameObject extractProjectilePrefab;
    public float projectileSpeed = 10;
    public float fireRate = 1;

    public UnityEvent OnTimeStorageHover;
    public UnityEvent OnTimeStorageUnhover;

    [Header("Events")]
    public UnityEvent OnPrimaryFire;
    public UnityEvent OnSecondaryFire;

    GameObject currentTarget;
    GameObject currentProjectile;
    TimeStorage targetStorage;
    bool _onCooldown;

    public Collider[] ignoreColliders;

    private void Start()
    {
        if (_inputProfile == null) Debug.LogError(gameObject.name + " does not have a player input");

        if (!insertProjectilePrefab)
        {
            Debug.Log("Projectile prefab missing");
            this.enabled = false;
        }
    }

    void SetTarget(GameObject target)
    {
        TimeStorage targetStorage = target?.GetComponent<TimeStorage>();
        if (targetStorage)
        {
            currentTarget = target;
            SetTimeCharge(targetStorage, 1);
        }
    }

    (Vector3, GameObject) GetTarget()
    {
        Ray shootRay = new Ray(shootOrigin.position, shootOrigin.forward);
        RaycastHit hit;
        Physics.Raycast(shootRay, out hit);
        return (hit.point, hit.collider?.gameObject);
    }

    IEnumerator Fire()
    {
        _onCooldown = true;

        Vector3 shootDir = shootOrigin.forward * 20f;

        RaycastHit hit;
        if (Physics.Raycast(shootOrigin.position, shootOrigin.forward, out hit))
            shootDir = hit.point - vfxOrigin.position;

        if (_inputProfile.GetPrimaryFireButton())
        {
            GameObject projectile = Instantiate(insertProjectilePrefab, vfxOrigin.position, Quaternion.identity);
            currentProjectile = projectile;
            ProjectileScript projectileScript = projectile.GetComponent<ProjectileScript>();
            projectileScript.SetSpeed(projectileSpeed);

            if (ignoreColliders.Length > 0)
                projectileScript.SetInstagator(ignoreColliders[0]);

            if (Physics.Raycast(shootOrigin.position, shootOrigin.forward, out hit))
                shootDir = hit.point - vfxOrigin.position;

            projectileScript.SetDirection(shootDir);

            projectileScript.OnHit += SetTarget;

            OnPrimaryFire.Invoke();
        }
        else if (_inputProfile.GetSecondaryFireButton())  // This should shoot a projectile from the target to the weapon
        {
            SetTarget(null);
            (Vector3, GameObject) target = GetTarget();
            TimeStorage storage = target.Item2?.GetComponent<TimeStorage>();
            if (storage)
            {
                GameObject projectile = Instantiate(extractProjectilePrefab, target.Item1, Quaternion.identity);
                currentProjectile = projectile;
                SetTimeCharge(storage, -1);

                ProjectileScript projectileScript = projectile.GetComponent<ProjectileScript>();
                projectileScript.SetSpeed(projectileSpeed);

                projectileScript.SetTarget(vfxOrigin);
                projectileScript.OnHit += SetTarget;
            }
            else
            {
                GameObject projectile = Instantiate(extractProjectilePrefab, shootOrigin.position + shootOrigin.forward * 20f, Quaternion.identity);
                currentProjectile = projectile;

                ProjectileScript projectileScript = projectile.GetComponent<ProjectileScript>();
                projectileScript.SetSpeed(projectileSpeed);

                projectileScript.SetTarget(vfxOrigin);
                projectileScript.OnHit += SetTarget;
            }

            OnSecondaryFire.Invoke();
        }

        yield return new WaitForSeconds(1 / fireRate);
        _onCooldown = false;
    }

    void SetTimeCharge(TimeStorage storage, int value)
    {
        if (storage != targetStorage)
        {
            targetStorage?.SetDefaultState();
            targetStorage = storage;
        }

        if (value > 0)
            storage.SetOnState();
        else
            storage.SetOffState();
    }

    TimeStorage kurrentTarget;
    private void Update()
    {
        if (Time.timeScale == 0) return;

        var test = GetTarget();
        TimeStorage newKurrentTarget = test.Item2?.GetComponent<TimeStorage>();
        if (!kurrentTarget && newKurrentTarget)
        {
            kurrentTarget = newKurrentTarget;
            OnTimeStorageHover.Invoke();
        }
        else if (kurrentTarget && !newKurrentTarget)
        {
            kurrentTarget = newKurrentTarget;
            OnTimeStorageUnhover.Invoke();
        }

        if (!_onCooldown && (_inputProfile.GetPrimaryFireButton() || _inputProfile.GetSecondaryFireButton()))
            StartCoroutine(Fire());
    }

}
