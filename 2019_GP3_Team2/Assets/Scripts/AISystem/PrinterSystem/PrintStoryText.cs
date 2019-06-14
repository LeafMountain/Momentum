using UnityEngine;

[AddComponentMenu("(つ♥v♥)つ/AI Behaviour/AI Story Text")]
public class PrintStoryText : MonoBehaviour
{
    [SerializeField] private AIStoryData _storyData;

    private PrintAIText _aiPrinter;

    private void Start()
    {
        _aiPrinter = FindObjectOfType<PrintAIText>();

        if (!_storyData)
        {
            Debug.LogError("There is no Story Data to " + this);
            return; 
        }

    }

    public string[] GetStoryText() => _storyData.text;

    public void WriteStoryText()
    {
        foreach (string text in _storyData.text)
            _aiPrinter.WriteResponse(text);
    }
}
