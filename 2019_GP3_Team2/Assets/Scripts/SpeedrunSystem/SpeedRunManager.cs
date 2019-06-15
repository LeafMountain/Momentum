using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;
using UnityEngine.UI;
using TMPro;

[DisallowMultipleComponent]
public class SpeedRunManager : MonoBehaviour
{
    [System.Serializable]
    public struct Timestamp {
        public string name;
        public TextMeshProUGUI diffUIText;
        public TextMeshProUGUI UIText;
        public float time;
    };

    [Header("Info")]
    [SerializeField] private float timeElapsed;
    [SerializeField] private bool isRunning;
    [SerializeField] private int lastTimeStampIndex = -1;
    [SerializeField] private float highScore;

    [Header("Variables")]
    [SerializeField] private TextMeshProUGUI mainTimerText;
    [SerializeField] private Timestamp[] timeStamps;
    [SerializeField] private TextMeshProUGUI highScoreText;
    [SerializeField] private Color betterThanTimeColor;
    [SerializeField] private Color worseThanTimeColor;

    [Header("Events")]
    public UnityEvent onStartSpeedRun;
    public UnityEvent onEndSpeedRun;

    void Start()
    {
        LoadHighScoreAndTimeStamps();
        UpdateHighScoreText();
        UpdateTimeStampTexts();
    }

    void Update()
    {
        if (isRunning)
        {
            timeElapsed += Time.deltaTime;
            float minutes = Mathf.Floor(timeElapsed / 60);
            float seconds = timeElapsed % 60;

            if (mainTimerText)
            {
                mainTimerText.text = string.Format("{0:00}:{1:00.00}", minutes, seconds);
            }
        }
    }

    [ContextMenu("StartSpeedRun")]
    public void StartSpeedRun()
    {
        isRunning = true;
        onStartSpeedRun.Invoke();
    }

    [ContextMenu("EndSpeedRun")]
    public void EndSpeedRun()
    {
        isRunning = false;
        if (timeElapsed < highScore)
        {
            SaveTimes();
        }
        onEndSpeedRun.Invoke();
    }

    [ContextMenu("SetNextTimeStamp")]
    public void SetNextTimeStamp()
    {
        if (lastTimeStampIndex + 1 < timeStamps.Length)
        {
            lastTimeStampIndex += 1;
            float diff = timeStamps[lastTimeStampIndex].time - timeElapsed;

            string minutes = Mathf.Floor(diff / 60).ToString("0");
            string seconds = (Mathf.Floor(diff) % 60).ToString("0");

            if (Mathf.Floor(diff / 60) >= 1)
            {
                if (diff > 0f)
                    timeStamps[lastTimeStampIndex].diffUIText.text = minutes + ":" + seconds;
                else
                    timeStamps[lastTimeStampIndex].diffUIText.text = "+" + minutes + ":" + seconds;
            }
            else
            {
                if (diff > 0f)
                    timeStamps[lastTimeStampIndex].diffUIText.text = diff.ToString("F1");
                else
                    timeStamps[lastTimeStampIndex].diffUIText.text = "+" + diff.ToString("F1");
            }

            if (diff > 0f)
                timeStamps[lastTimeStampIndex].diffUIText.color = betterThanTimeColor;
            else
                timeStamps[lastTimeStampIndex].diffUIText.color = worseThanTimeColor;
        }
    }

    public void SaveTimes()
    {
        PlayerPrefs.SetFloat("SpeedRunHighScore", timeElapsed);

        for (int i = 0; i < timeStamps.Length; i++)
        {
            PlayerPrefs.SetFloat("SpeedRunHighScoreTS" + i, timeStamps[i].time);
        }

        PlayerPrefs.Save();
    }

    public void LoadHighScoreAndTimeStamps()
    {
        if (PlayerPrefs.HasKey("SpeedRunHighScore"))
        {
            highScore = PlayerPrefs.GetFloat("SpeedRunHighScore");
        }

        for (int i = 0; i < timeStamps.Length; i++)
        {
            if (PlayerPrefs.HasKey("SpeedRunHighScoreTS" + i))
            {
                timeStamps[i].time = PlayerPrefs.GetFloat("SpeedRunHighScoreTS" + i);
            }
        }
    }

    public void UpdateHighScoreText()
    {
        string minutes = Mathf.Floor(highScore / 60).ToString("00");
        string seconds = (Mathf.Floor(highScore) % 60).ToString("00");
        if (highScoreText)
        {
            highScoreText.text = minutes + ":" + seconds;
        }
    }

    public void UpdateTimeStampTexts()
    {
        if (timeStamps.Length >= 1)
        {
            for (int i = 0; i < timeStamps.Length; i++)
            {
                string minutes = Mathf.Floor(timeStamps[i].time / 60).ToString("00");
                string seconds = (Mathf.Floor(timeStamps[i].time) % 60).ToString("00");
                if (timeStamps[i].UIText)
                {
                    timeStamps[i].UIText.text = minutes + ":" + seconds;
                }
            }
        }
    }
}
