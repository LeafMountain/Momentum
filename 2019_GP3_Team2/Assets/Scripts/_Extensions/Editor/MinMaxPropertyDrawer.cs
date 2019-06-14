using UnityEditor;
using UnityEngine;

[CustomPropertyDrawer(typeof(MinMaxAttribute))]
public class MinMaxPropertyDrawer : PropertyDrawer
{
    public override void OnGUI(Rect position, SerializedProperty property, GUIContent content)
    {
       MinMaxAttribute minMax = attribute as MinMaxAttribute; 

        // Determine that Vector2 accessors is valid
        if (property.propertyType == SerializedPropertyType.Vector2)
        {
            // Set values of look
            float lableWidth = EditorGUIUtility.labelWidth;
            float widthField = EditorGUIUtility.fieldWidth * 0.5f;
            float sliderWidth = position.width - lableWidth - 2f * widthField;
            float sliderPadding = 5f;

            //Create look
            Rect lableRect = new Rect(position.x, position.y, lableWidth, position.height);
            Rect sliderRect = new Rect(position.x + lableWidth + widthField + sliderPadding, position.y, sliderWidth - 2f * sliderPadding, position.height);
            Rect minFieldRect = new Rect(position.x + lableWidth, position.y, widthField, position.height);
            Rect maxFieldRect = new Rect(position.x + lableWidth + widthField + sliderWidth, position.y, widthField, position.height);
            EditorGUI.LabelField(lableRect, property.displayName);

            // Undo check
            EditorGUI.BeginChangeCheck();
            {
                Vector2 sliderValue = property.vector2Value;
                EditorGUI.MinMaxSlider(sliderRect, ref sliderValue.x, ref sliderValue.y, minMax.minLimit,
                    minMax.maxLimit);

                sliderValue.x = EditorGUI.FloatField(minFieldRect, sliderValue.x);
                sliderValue.x = Mathf.Clamp(sliderValue.x, minMax.minLimit, Mathf.Min(minMax.maxLimit, sliderValue.y));

                sliderValue.y = EditorGUI.FloatField(maxFieldRect, sliderValue.y);
                sliderValue.y = Mathf.Clamp(sliderValue.y, Mathf.Max(minMax.minLimit, sliderValue.x), minMax.maxLimit);

                if (EditorGUI.EndChangeCheck())
                    property.vector2Value = sliderValue;
            }
        }
        else
            Debug.LogError(minMax.GetType().Name + " can only be used on Vector2 fields");
    }
}
