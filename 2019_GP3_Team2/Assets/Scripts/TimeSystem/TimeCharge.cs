using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TimeCharge : MonoBehaviour
{
    public int chargeValue = 1;
    TimeStorage storage;

    public void SetChargeValue(int value)
    {
        OnDisable();
        chargeValue = value;
        OnEnable();
    }

    void OnEnable()
    {
        storage = GetComponent<TimeStorage>();
        // storage?.InsertTime(chargeValue);
        if (chargeValue > 0)
            storage?.SetOnState();
        else
            storage?.SetOffState();
    }

    void OnDisable()
    {
        storage?.SetOnState();
        // storage?.ExtractTime(-chargeValue);
    }
}
