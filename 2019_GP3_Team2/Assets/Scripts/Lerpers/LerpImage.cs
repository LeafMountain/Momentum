using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

[RequireComponent(typeof(Image))]
public class LerpImage : MonoBehaviour
{
    public Color colorZero = Color.black;
    public Color colorOne = Color.clear;
    public Color color;
    public float duration = 0.1f;

    Image image;
    float time;
    float targetTime = 0;

    void Awake()
    {
        image = GetComponent<Image>();
    }

    public void SetTime(float t)
    {
        if (!enabled) return;
        targetTime = Mathf.Clamp01(t);
        StartCoroutine(Lerp());
    }

    public void Toggle()
    {
        int target = Mathf.RoundToInt(targetTime);
        target *= -1;
        SetTime(target);
    }

    IEnumerator Lerp()
    {
        float direction = (targetTime < 1) ? -1 : 1;
        time += Time.deltaTime / duration * direction;
        time = Mathf.Clamp01(time);

        color = Color.Lerp(colorZero, colorOne, time);
        image.color = color;

        yield return new WaitForEndOfFrame();
        if (time != targetTime) StartCoroutine(Lerp());
    }
}
