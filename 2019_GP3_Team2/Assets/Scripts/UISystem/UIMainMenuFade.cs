using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class UIMainMenuFade : MonoBehaviour
{

    //public GameObject[] levelButtons;



    public Image buttonImageLevelSelect;

    private void OnEnable()
    {
        StartCoroutine(FadeImage(false));
    }




    private void Start()
    {
        //StartCoroutine(FadeImage(false));
    }

    /*
    public void OnButtonClick()
    {
        // fades the image out when you click
        StartCoroutine(FadeImage(true));
    }
    */

    IEnumerator FadeImage(bool fadeAway)
    {
        // fade from opaque to transparent
        if (fadeAway)
        {
            // loop over 1 second backwards
            for (float i = 1; i >= 0; i -= Time.deltaTime)
            {
                // set color with i as alpha
                buttonImageLevelSelect.color = new Color(1, 1, 1, i);
                yield return null;
            }
        }

        
        // fade from transparent to opaque
        else
        {
            // loop over 1 second
            for (float i = 0; i <= 1; i += Time.deltaTime)
            {
                // set color with i as alpha
                buttonImageLevelSelect.color = new Color(1, 1, 1, i);
                yield return null;
            }
        }
        
    }



    /*
    public float duration = 1;
    public Color color = Color.clear;

    Image[] imageUI;
    Color currentColor;
    Color UiImageColor;

    float time;

    void Start()
    {
        imageUI = GetComponentsInChildren<Image>();
        //currentColor = imageUI.color;

        foreach (Image uiimage in imageUI)
        {
            uiimage.GetComponentInChildren<Image>();
            currentColor = uiimage.color;
            UiImageColor = uiimage.color;

        }
    }

    void Update()
    {
        time += Time.deltaTime / duration;
        time = Mathf.Clamp01(time);

        currentColor = Color.Lerp(currentColor, color, time);
        UiImageColor = currentColor;
        if (time == 1) this.enabled = false;

    }

    public void SetFadeColor(Color color) => this.color = color;

    */

    /*

void Update()
{
    if (Input.GetKeyUp(KeyCode.T))

        //foreach (GameObject button in levelButtons)
        //{
            {
                StartCoroutine(FadeTo(0.0f, 1.0f));
            }
        //}

    //foreach (GameObject button in levelButtons)
    //{
        if (Input.GetKeyUp(KeyCode.F))
        {
            StartCoroutine(FadeTo(1.0f, 1.0f));
        }
    //}
}

IEnumerator FadeTo(float aValue, float aTime)
{
    foreach (GameObject button in levelButtons)
    {
        float alpha = transform.GetComponent<Image>().material.color.a;
        for (float t = 0.0f; t < 1.0f; t += Time.deltaTime / aTime)
        {
            Color newColor = new Color(1, 1, 1, Mathf.Lerp(alpha, aValue, t));
            transform.GetComponent<Image>().material.color = newColor;
            yield return null;
        }
    }
}

*/
}
