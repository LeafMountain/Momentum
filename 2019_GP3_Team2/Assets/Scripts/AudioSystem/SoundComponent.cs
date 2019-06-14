using UnityEngine;
using UnityEngine.Audio;

[DisallowMultipleComponent, RequireComponent(typeof(AudioSource)), AddComponentMenu("(つ♥v♥)つ/Sound/Sound Manager")]
public class SoundComponent : MonoBehaviour
{
    [SerializeField] AudioSource _source;
    public Vector2 volumeMinMax = new Vector2(0.35f, 0.45f);
    public Vector2 pitchMinMax = new Vector2(0.52f, 0.6f);
    public AudioMixerGroup output;

    private void Start()
    {
        //_source = GetComponent<AudioSource>();

        if (!_source)
        {
            Debug.LogError("There is no Audio Source in " + gameObject.name);
            return;
        }
    }

    public void PlaySound(AudioClip clip)
    {
        if (!clip)
        {
            Debug.LogError("There is no Autio Clip Source in " + gameObject.name);
            return;
        }
        else
        {
            float volume = Random.Range(volumeMinMax.x, volumeMinMax.y);
            float pitch = Random.Range(pitchMinMax.x, pitchMinMax.y);
            _source.volume = volume;
            _source.pitch = pitch;
            _source.clip = clip;
            _source.outputAudioMixerGroup = output;

            _source.Play();
        }
    }

    public void PlaySoundOneShot(AudioClip clip)
    {
        if (!clip) return;

        GameObject go = new GameObject();
        go.transform.position = transform.position;
        AudioSource audioSource = go.AddComponent<AudioSource>();

        float volume = Random.Range(volumeMinMax.x, volumeMinMax.y);
        float pitch = Random.Range(pitchMinMax.x, pitchMinMax.y);

        audioSource.volume = volume;
        audioSource.pitch = pitch;
        audioSource.clip = clip;
        audioSource.outputAudioMixerGroup = output;
        audioSource.Play();
        Destroy(go, clip.length);
    }

}
