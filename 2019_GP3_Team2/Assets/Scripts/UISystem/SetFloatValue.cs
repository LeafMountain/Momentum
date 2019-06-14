using UnityEngine;
using UnityEngine.UI;

public class SetFloatValue : MonoBehaviour
{
    public Slider slider;
    public FloatVariable value;

    void Start()
    {
        slider.value = value.value;
        slider.onValueChanged.AddListener(SetValue);
    }

    public void SetValue(float value)
    {
        this.value.SetValue(value);
    }
}
