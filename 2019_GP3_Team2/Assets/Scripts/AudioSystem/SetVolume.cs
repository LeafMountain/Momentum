using TMPro;
using UnityEngine;
using UnityEngine.Audio;
using UnityEngine.UI;

public class SetVolume : MonoBehaviour
{
    [SerializeField] private AudioMixer _audioMixer;
    [SerializeField] private TextMeshProUGUI _percentText;

    public string propertyName;

    private Slider _slider;

    void OnEnable()
    {
        _slider = GetComponent<Slider>();

        float defaultVolume;
        _audioMixer.GetFloat(propertyName, out defaultVolume);
        float volumePercentage = Mathf.InverseLerp(-80, 20, defaultVolume);
        _slider.value = volumePercentage;

        _percentText.text = Mathf.RoundToInt(volumePercentage * 100) + "%";
    }

    public void SetTheVolume(float value) => SetTheVolume(propertyName, value);
    

    public void SetTheVolume(string propertyName, float value)
    {
        _percentText.text = Mathf.RoundToInt(value * 100) + "%";

        value = Mathf.Lerp(-80, 20, value);
        _audioMixer.SetFloat(propertyName, value);
    }

    public void SetVolumeMaster(float sliderValue) => SetTheVolume("MasterVolume", sliderValue); 

    public void SetVolumeSFX(float sliderValue) => SetTheVolume("SFXVolume", sliderValue); 

    public void SetVolumeAmbient(float sliderValue) => SetTheVolume("AmbientVolume", sliderValue);

    public void UpdatePercentage(float value) => _percentText.text = Mathf.RoundToInt(value * 100) + "%";

}
