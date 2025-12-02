using UnityEngine;

public class HammerController : MonoBehaviour
{
    [Header("Inertie")]
    public float posLag = 5f;
    public float rotLag = 5f;

    [Header("Amplitude du retard")]
    public float posAmount = 0.05f;
    public float rotAmount = 5f;

    private Vector3 idlePos;
    private Quaternion idleRot;

    void Start()
    {
 
        idlePos = transform.localPosition;
        idleRot = transform.localRotation;
    }

    void LateUpdate()
    {
        float mouseX = Input.GetAxis("Mouse X");
        float mouseY = Input.GetAxis("Mouse Y");

        Vector3 posOffset = new Vector3(
            -mouseX * posAmount,
            -mouseY * posAmount,
            0f
        );

   
        Quaternion rotOffset = Quaternion.Euler(
            -mouseY * rotAmount,
            -mouseX * rotAmount,
            0f
        );

        Vector3 targetPos = idlePos + posOffset;
        Quaternion targetRot = idleRot * rotOffset;

        
        transform.localPosition = Vector3.Lerp(
            transform.localPosition,
            targetPos,
            Time.deltaTime * posLag
        );

        transform.localRotation = Quaternion.Slerp(
            transform.localRotation,
            targetRot,
            Time.deltaTime * rotLag
        );
    }
}
