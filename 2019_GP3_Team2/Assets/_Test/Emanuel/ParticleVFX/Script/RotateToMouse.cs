using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class RotateToMouse : MonoBehaviour {
    public Camera cam;
    public float maximumlenght;

    private Ray rayMouse;
    private Vector3 pos;
    private Vector3 direction;
    private Quaternion rotation;

    public Vector3 MousePosition { get; private set; }

    void Update() {
        if (cam != null) {
            RaycastHit hit;
            var mousPos = Input.mousePosition;
            rayMouse = cam.ScreenPointToRay (MousePosition);
            if (Physics.Raycast(rayMouse.origin, rayMouse.direction, out hit, maximumlenght)) {
                RotateToMouseDirection(gameObject, hit.point);
            }

        } else {
            Debug.Log("no Camera");
        }



    }





        void RotateToMouseDirection (GameObject obj, Vector3 destination) {
            direction = destination - obj.transform.position;
            rotation = Quaternion.LookRotation(direction);
            obj.transform.localRotation = Quaternion.Lerp (obj.transform.rotation, rotation, 1);
        }
    }

