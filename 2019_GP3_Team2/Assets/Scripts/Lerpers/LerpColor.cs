using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[RequireComponent(typeof(MeshRenderer))]
public class LerpColor : MonoBehaviour
{
    public ColorVariable colorZero;
    public ColorVariable colorOne;
    public Color color;
    public int materialIndex = 0;
    public string colorPropertyName = "_EmissionColor";
    public float duration = .1f;

    MeshRenderer renderer;
    float time;
    float targetTime = 0;

    void Awake()
    {
        if (!colorZero || !colorOne)
        {
            Debug.LogWarning("Missing colors");
            enabled = false;
        }
        renderer = GetComponent<MeshRenderer>();
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
        renderer.materials[materialIndex].SetColor(colorPropertyName, color);

        yield return new WaitForEndOfFrame();
        if (time != targetTime) StartCoroutine(Lerp());
    }
}
