using System;
using System.Collections.Generic;
using UnityEngine;
using System.Linq;
using Random = UnityEngine.Random;

[CreateAssetMenu(fileName = "X ResponseData", menuName = "ResponseData Info/Create New Response Data", order = 1)]
public class ResponseData : ScriptableObject
{
    [Header("AI Responses"), Tooltip("How many different type of responses depending on specific AI currentAIMood")]
    [SerializeField] private Response[] _moodResponses;

    [Header("AI Is Angry - barrier is 0"), Space(25), Tooltip("The AI will say this if it's mood is 0.")]
    [SerializeField] private Response _hateResponses;

    private void Start() => _hateResponses.happyBarrier = 0;

    private string GetRandomAngryDefault() => _hateResponses._response.Length == 0 ? "..." : _hateResponses._response[Random.Range(0, _hateResponses._response.Length)];

    private AudioClip GetRandomAngryDefaultClip()
    {
        if (_hateResponses._responseClip.Length == 0)
            return null;
        
        else
            return _hateResponses._responseClip[Random.Range(0, _hateResponses._responseClip.Length)];
    }

    public string GetResponse(int currentAIMood)
    {
        List<Response> relevantRespones = new List<Response>();

        relevantRespones.AddRange(_moodResponses.Where(response => response.happyBarrier <= currentAIMood));
        relevantRespones.OrderByDescending(response => response.happyBarrier);

        return relevantRespones.Count == 0 ? GetRandomAngryDefault() : relevantRespones[0].GetResponseText();
    }
   
    public AudioClip GetRelevantResponseClip(int currentAIMood)
    {
        List<Response> relevantRespones = new List<Response>();

        relevantRespones.AddRange(_moodResponses.Where(response => response.happyBarrier <= currentAIMood));
        relevantRespones.OrderByDescending(response => response.happyBarrier);

        return relevantRespones.Count == 0 ? GetRandomAngryDefaultClip() : relevantRespones[0].GetResponseClip();
    }
}

[Serializable]
public struct Response
{
    [Range(0, 100), Tooltip("The barrier for what mood the AI must be to tell the line")]
    public int happyBarrier;

    public string[] _response;
    public AudioClip[] _responseClip;
    
    public string GetResponseText() => _response[Random.Range(0, _response.Length)];

    public AudioClip GetResponseClip() => _responseClip.Length == 0 ? null : _responseClip[Random.Range(0, _responseClip.Length)];

    
}