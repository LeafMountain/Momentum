using UnityEngine;


public class AIBehaviourComponent : MonoBehaviour
{
    #region Inspector Variables

    [Tooltip("The current mood of the AI")]
    [HideInInspector] public IntVariable currentMood;

    /// Events
    [HideInInspector] public ScriptableEvent deathEvent;
    [HideInInspector] public ScriptableEvent finishSectionEvent;
    [HideInInspector] public ScriptableEvent tooLateEvent;
    [HideInInspector] public ScriptableEvent standingStillEvent;

    /// Responses
    [HideInInspector] public ResponseData deathResponse;
    [HideInInspector] public ResponseData finishSectionResponse;
    [HideInInspector] public ResponseData tooLateResponse;
    [HideInInspector] public ResponseData standingStillResponse;

    /// AI Faces
    [Header("AI Faces - Sprites"), Space(10)]
    [SerializeField] private Sprite [] _happyFaces;
    [SerializeField] private Sprite [] _mediumFaces;
    [SerializeField] private Sprite [] _angryFaces;

    [Header("AI Face Barrier"), MinMax(0, 100)]
    [Tooltip("Under the Min-value and the AI is angry \nOver the Max-value and the AI is happy \n in between and it has medium mood")]
    [SerializeField] private Vector2 _faceBarrier;

    #endregion

    private PrintAIText _aiPrinter;
    private AudioSource _source;

    private void Start()
    {
        _aiPrinter = GetComponentInChildren<PrintAIText>();
        _source = GetComponent<AudioSource>();

        if (!_source)
        {
            Debug.LogError("There is no " + _source.name + " connected to " + this);
            return;
        }

        if (!_aiPrinter)
        {
            Debug.LogError("There is no " + _aiPrinter.name + " as I child in " + this);
            return;
        }

        if (!currentMood)
        {
            Debug.LogError("There is no " + currentMood.name + " connected to " + this);
            return;
        }
        
        /// Connect Events
        {
            if (!deathEvent || !finishSectionEvent  || !standingStillEvent)
            {
                Debug.LogError("The " + this + " are missing event connection");
                return;
            }

            deathEvent.myEvent += OnDeath;
            finishSectionEvent.myEvent += OnFinishSection;
            tooLateEvent.myEvent += OnTooLate;
            standingStillEvent.myEvent += OnStandingStill;
        }
    }

    public void React(ResponseData data)
    {
        _aiPrinter.WriteResponse(data.GetResponse(currentMood.value));

        AudioClip clip = data.GetRelevantResponseClip(currentMood.value);
        if(!clip) return;

        _source.PlayOneShot(clip);
    }
    
    #region Events
    private void OnDeath() => React(deathResponse);
    private void OnFinishSection() => React(finishSectionResponse);
    private void OnTooLate() => React(tooLateResponse);
    private void OnStandingStill() => React(standingStillResponse);
    
    #endregion

    #region FaceSwap

    public Sprite GetCurrentFace()
    {
        if (currentMood.value <= _faceBarrier.x)
            return _angryFaces[Random.Range(0, _angryFaces.Length)];

        if (currentMood.value >= _faceBarrier.y)
            return _happyFaces[Random.Range(0, _happyFaces.Length)];

        else
            return _mediumFaces[Random.Range(0, _mediumFaces.Length)];
    }
    #endregion
}

