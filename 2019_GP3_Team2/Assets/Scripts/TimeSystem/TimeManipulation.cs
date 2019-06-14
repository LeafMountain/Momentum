using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;

[RequireComponent(typeof(TimeStorage))]
[DisallowMultipleComponent, AddComponentMenu("(つ♥v♥)つ/Time Manipulation/Manipulation Transferer")]
public class TimeManipulation : MonoBehaviour
{
    public TimeStorage timeStorage;
    public UnityEventGameObject OnExtract;
    public UnityEventGameObject OnInsert;

    public TimeCharge[] charges = new TimeCharge[1];    // Holds 1 charge

    void Start()
    {
        if (!timeStorage)
            timeStorage = GetComponent<TimeStorage>();

        for (int i = 0; i < charges.Length; i++)
        {
            charges[i] = new TimeCharge();
        }
    }

    public void ExtractTimeFrom(GameObject go)
    {
        TimeStorage storage = go?.GetComponent<TimeStorage>();
        if (storage)
        {
            if (charges[0])
                DestroyImmediate(charges[0]);
            charges[0] = go.AddComponent<TimeCharge>();
            charges[0].SetChargeValue(-1);

            OnExtract.Invoke(go);
        }
    }

    public void InsertTimeTo(GameObject go)
    {
        TimeStorage storage = go?.GetComponent<TimeStorage>();
        if (storage)
        {
            if (charges[0])
                DestroyImmediate(charges[0]);
            charges[0] = go.AddComponent<TimeCharge>();
            charges[0].SetChargeValue(1);

            OnInsert.Invoke(go);
        }
    }

    // void Transfer(TimeStorage from, TimeStorage to, int amount)
    // {
    //     int extractedTime = from.ExtractTime(amount);
    //     int overflow = to.InsertTime(extractedTime);
    //     from.InsertTime(overflow);
    // }
}
