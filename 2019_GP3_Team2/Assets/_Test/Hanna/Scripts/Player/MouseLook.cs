using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MouseLook : MonoBehaviour
{
    Vector2 mouseLook;
    Vector2 smoothV;
    public float cameraSensitivity = 5f;
    public float cameraSmoothing = 2f;

    GameObject playerCharacter;

    void Start()
    {
        playerCharacter = this.transform.parent.gameObject;
    }

    
    void Update()
    {
        var md = new Vector2(Input.GetAxisRaw("Mouse X"), Input.GetAxisRaw("Mouse Y"));

        md = Vector2.Scale(md, new Vector2(cameraSensitivity * cameraSmoothing, cameraSensitivity * cameraSmoothing));
        smoothV.x = Mathf.Lerp(smoothV.x, md.x, 1f / cameraSmoothing);
        smoothV.y = Mathf.Lerp(smoothV.y, md.y, 1f / cameraSmoothing);
        mouseLook += smoothV;

        transform.localRotation = Quaternion.AngleAxis(-mouseLook.y, Vector3.right);
        playerCharacter.transform.localRotation = Quaternion.AngleAxis(mouseLook.x, playerCharacter.transform.up);
    }
}
