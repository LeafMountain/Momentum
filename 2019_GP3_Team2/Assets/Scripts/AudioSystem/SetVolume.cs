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

    void Start()
    {
        _slider = GetComponent<Slider>();

        float defaultVolume;
        _audioMixer.GetFloat(propertyName, out defaultVolume);
        _slider.value = defaultVolume;

        _percentText.text = Mathf.RoundToInt(_slider.value * 10) + "%";
    }

    public void SetTheVolume(float value)
    {
        _audioMixer.SetFloat(propertyName, Mathf.Log10(value) * 20);
        _percentText.text = Mathf.RoundToInt(value * 100) + "%";
    }
    // public void SetVolumeMaster(float sliderValue) => _audioMixer.SetFloat("MasterVolume", Mathf.Log10(sliderValue) * 20); 

    // public void SetVolumeSFX(float sliderValue) => _audioMixer.SetFloat("SFXVolume", Mathf.Log10(sliderValue) * 20); 

    // public void SetVolumeAmbient(float sliderValue) => _audioMixer.SetFloat("AmbientVolume", Mathf.Log10(sliderValue) * 20);

    // public void UpdatePercentage(float value) => _percentText.text = Mathf.RoundToInt(value * 100) + "%";

}
