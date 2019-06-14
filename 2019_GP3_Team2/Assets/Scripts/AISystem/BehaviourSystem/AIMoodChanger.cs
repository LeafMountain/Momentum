using UnityEngine;

[AddComponentMenu("(つ♥v♥)つ/AI Behaviour/AI Mood Changer")]
public class AIMoodChanger : MonoBehaviour
{
    private AIBehaviourComponent _aiBehaviour;
    private FaceChanger _aiFace;

    private void Start()
    {
        _aiBehaviour = FindObjectOfType<AIBehaviourComponent>();
        _aiFace = FindObjectOfType<FaceChanger>();
    }

    public void IncreaseMood(int moodToAdd)
    {
        _aiFace.UpdateFace();
        if (_aiBehaviour.currentMood.value + moodToAdd > 100)
            _aiBehaviour.currentMood.value = 100;

        else
            _aiBehaviour.currentMood.value += moodToAdd;
    }

    public void DecreaseMood(int moodToReduce)
    {
        _aiFace.UpdateFace();
        if (_aiBehaviour.currentMood.value - moodToReduce < 0)
            _aiBehaviour.currentMood.value = 0;

        else
            _aiBehaviour.currentMood.value -= moodToReduce;
    }
}
