using UnityEngine;
using Sirenix.OdinInspector;

public class Crate : MonoBehaviour
{
    [SerializeField]
    private Renderer targetRenderer;

    private static readonly int BoxSizeID = Shader.PropertyToID("_BoxSize");

    [Button("Set Brick Width")]
    public void SetBrickWidth(float width)
    {
        if (targetRenderer == null)
            targetRenderer = GetComponent<Renderer>();

        if (targetRenderer == null)
        {
            Debug.LogWarning("Crate: Rederer not found.");
            return;
        }

        var mat = targetRenderer.sharedMaterial;
        if (mat == null)
        {
            Debug.LogWarning("Crate: Material not set.");
            return;
        }

        mat.SetFloat(BoxSizeID, width);
    }
}
