using UnityEngine;

[RequireComponent(typeof(MeshRenderer))]
[RequireComponent(typeof(TimeStorage))]
[DisallowMultipleComponent, AddComponentMenu("(つ♥v♥)つ/Time Manipulation/Change Emission")]
public class LerpEmission : MonoBehaviour
{
    //Hue, Saturation, Brightness color
    private HSBColor _colorHSB;
    private Material _material;

    private void Awake()
    {
        _material = gameObject.GetComponent<Renderer>().material;
        _material.EnableKeyword("_EMISSION");

        _colorHSB = HSBColor.FromColor(_material.color);
        _material.color = _colorHSB.ToColor();
    }
    
    public void SetTime(float t)
    {
        GetComponent<Renderer>().material.SetColor("_EmissionColor",
            HSBColor.ToColor(HSBColor.Lerp(HSBColor.FromColor(Color.clear), _colorHSB, t)));
    }
}
