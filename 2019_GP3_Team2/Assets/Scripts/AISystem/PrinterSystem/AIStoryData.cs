using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[CreateAssetMenu(fileName = "StoryData X", menuName = "Story Info/Create New Story Data", order = 1)]
public class AIStoryData : ScriptableObject
{
    [Header("AI Text")]
    [Tooltip("Each line is a new page the AI will say")]
    public string[] text;
}
