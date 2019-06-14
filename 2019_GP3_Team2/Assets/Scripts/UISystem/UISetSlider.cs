using TMPro;
using UnityEngine;
using UnityEngine.UI;

[RequireComponent(typeof(Slider))]
public class UISetSlider : MonoBehaviour
{
    public Slider slider;
    public FloatVariable floatVariable;
    public float maxValue = 3;

    [SerializeField] private TextMeshProUGUI _percentText;

    void Start()
    {
        slider.maxValue = maxValue;
        slider.value = floatVariable.value;
        slider.onValueChanged.AddListener(OnValueCanged);
        _percentText.text = Mathf.RoundToInt((slider.value / maxValue) * 100) + "%";

    }

    void OnValueCanged(float value)
    {
        floatVariable.SetValue(value);
        _percentText.text = Mathf.RoundToInt((value / maxValue) * 100) + "%";
    }
}
