using UnityEngine;

public class TimeScaleManager : MonoBehaviour
{
    private bool toogle = false;

    public void SetTimeScaleToggle()
    {
        toogle = !toogle;

        if (toogle)
            Time.timeScale = 0;

        else
            Time.timeScale = 1;
    }

    public void ActivateTimeScale() => Time.timeScale = 1;
    public void DeactivateTimeScale() => Time.timeScale = 0;
    public void SetTimeScale(float value) => Time.timeScale = value;

}
