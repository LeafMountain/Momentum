using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class UIFade : MonoBehaviour
{
    public float duration = 1;
    public Color color = Color.clear;

    Image image;
    Color currentColor;

    float time;

    void Start()
    {
        image = GetComponentInChildren<Image>();
        currentColor = image.color;
    }

    void Update()
    {
        time += Time.deltaTime / duration;
        time = Mathf.Clamp01(time);

        currentColor = Color.Lerp(currentColor, color, time);
        image.color = currentColor;
        if (time == 1) this.enabled = false;

    }

    public void SetFadeColor(Color color) => this.color = color;
}
