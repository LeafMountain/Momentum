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
    public struct Timestamp
    {
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
    //[SerializeField] private TextMeshProUGUI highScoreText;
    //[SerializeField] private TextMeshProUGUI highScoreDiff;
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

    public void SetNextTimeStamp()
    {
        if (lastTimeStampIndex + 1 < timeStamps.Length)
        {
            lastTimeStampIndex += 1;

            if (timeStamps[lastTimeStampIndex].time == Mathf.Infinity)
            {
                string minutes = Mathf.Floor(timeElapsed / 60).ToString("00");
                string seconds = (Mathf.Floor(timeElapsed) % 60).ToString("00");
                if (timeStamps[lastTimeStampIndex].UIText)
                {
                    timeStamps[lastTimeStampIndex].UIText.text = minutes + ":" + seconds;
                }
            }
            else
            {
                float diff = timeElapsed - timeStamps[lastTimeStampIndex].time;

                string minutes = Mathf.Floor(diff / 60).ToString("0");
                string seconds = (Mathf.Floor(diff) % 60).ToString("0");

                if (Mathf.Floor(diff / 60) >= 1)
                {
                    if (diff < 0f)
                        timeStamps[lastTimeStampIndex].diffUIText.text = minutes + ":" + seconds;
                    else
                        timeStamps[lastTimeStampIndex].diffUIText.text = "+" + minutes + ":" + seconds;
                }
                else
                {
                    if (diff < 0f)
                        timeStamps[lastTimeStampIndex].diffUIText.text = diff.ToString("F1");
                    else
                        timeStamps[lastTimeStampIndex].diffUIText.text = "+" + diff.ToString("F1");
                }

                if (diff < 0f)
                    timeStamps[lastTimeStampIndex].diffUIText.color = betterThanTimeColor;
                else
                    timeStamps[lastTimeStampIndex].diffUIText.color = worseThanTimeColor;
            }

            timeStamps[lastTimeStampIndex].time = timeElapsed;

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

    [ContextMenu("ResetHighScores")]
    public void ResetHighScores()
    {
        PlayerPrefs.DeleteAll();
    }

    public void LoadHighScoreAndTimeStamps()
    {
        if (PlayerPrefs.HasKey("SpeedRunHighScore"))
        {
            highScore = PlayerPrefs.GetFloat("SpeedRunHighScore");
            if (highScore <= 0.0f)
            {
                highScore = Mathf.Infinity;
            }
        }
        else
        {
            if (highScore <= 0.0f)
            {
                highScore = Mathf.Infinity;
            }
        }

        for (int i = 0; i < timeStamps.Length; i++)
        {
            if (PlayerPrefs.HasKey("SpeedRunHighScoreTS" + i))
            {
                timeStamps[i].time = PlayerPrefs.GetFloat("SpeedRunHighScoreTS" + i);
                if (timeStamps[i].time <= 0.0f)
                {
                    timeStamps[i].time = Mathf.Infinity;
                }
            }
            else
            {
                if (timeStamps[i].time <= 0.0f)
                {
                    timeStamps[i].time = Mathf.Infinity;
                }
            }
        }
    }

    public void UpdateHighScoreText()
    {
        if (highScore == Mathf.Infinity)
        {
            if (timeStamps.Length > 0 && timeStamps[timeStamps.Length - 1].UIText)
            {
                timeStamps[timeStamps.Length - 1].UIText.text = "00:00";
            }
        }
        else
        {
            string minutes = Mathf.Floor(highScore / 60).ToString("00");
            string seconds = (Mathf.Floor(highScore) % 60).ToString("00");
            if (timeStamps.Length > 0 && timeStamps[timeStamps.Length - 1].UIText)
            {
                timeStamps[timeStamps.Length - 1].UIText.text = minutes + ":" + seconds;
            }
        }
    }

    public void UpdateTimeStampTexts()
    {
        if (timeStamps.Length >= 1)
        {
            for (int i = 0; i < timeStamps.Length; i++)
            {
                if (timeStamps[i].time == Mathf.Infinity)
                {
                    timeStamps[i].UIText.text = "00:00";
                }
                else
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
}
