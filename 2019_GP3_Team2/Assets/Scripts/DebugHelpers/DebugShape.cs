using UnityEngine;

public class DebugShape : MonoBehaviour
{
    public enum Shape
    {
        Cube,
        Sphere
    }

    public Shape shape;
    public bool vizualizeAlways;

    public Vector3 cubeSize;
    public float radius;

    public Color color = Color.white;

    void OnDrawGizmos()
    {
        if (vizualizeAlways)
        {
            DrawGizmos();
        }
    }

    void OnDrawGizmosSelected()
    {
        if (!vizualizeAlways)
        {
            DrawGizmos();
        }
    }

    void DrawGizmos()
    {
        Gizmos.color = color;
        if (shape == Shape.Cube)
            Gizmos.DrawCube(transform.position, cubeSize);
        else if (shape == Shape.Sphere)
            Gizmos.DrawSphere(transform.position, radius);
    }
}
