using UnityEngine;
using UnityEngine.UI;

public class UIFloatUpdater : MonoBehaviour
{
    public FloatVariable variable;
    public Slider slider;

    void Start()
    {
        variable.OnValueChanged += SetValue;
    }

    void SetValue()
    {
        slider.value = variable.value;
    }
}
