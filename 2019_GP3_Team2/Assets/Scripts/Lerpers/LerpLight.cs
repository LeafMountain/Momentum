using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[RequireComponent(typeof(Light))]
public class LerpLight : MonoBehaviour
{
    public ColorVariable colorZero;
    public ColorVariable colorOne;
    public float duration = .2f;

    Light light;
    float time;
    float targetTime;
    Color color;

    void Awake()
    {
        if (!colorZero || !colorOne)
        {
            Debug.LogWarning("Missing colors");
            enabled = false;
        }
        light = GetComponent<Light>();
    }

    public void SetTime(float t)
    {
        if (!enabled) return;
        targetTime = Mathf.Clamp01(t);
        StartCoroutine(Lerp());
    }

    IEnumerator Lerp()
    {
        float direction = (targetTime < 1) ? -1 : 1;
        time += Time.deltaTime / duration * direction;
        time = Mathf.Clamp01(time);

        color = Color.Lerp(colorZero.color, colorOne.color, time);
        light.color = color;

        yield return new WaitForEndOfFrame();
        if (time != targetTime) StartCoroutine(Lerp());
    }
}
