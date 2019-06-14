using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

[RequireComponent(typeof(Image))]
public class CrosshairComponent : MonoBehaviour
{
    public Sprite activeSprite;
    public Sprite inactiveSprite;

    private Image _image;
    void Start()
    {
        _image = GetComponent<Image>();
        SetInactiveState();
    }

    public void SetActiveState()
    {
        _image.sprite = activeSprite;
    }

    public void SetInactiveState()
    {
        _image.sprite = inactiveSprite;
    }
}
