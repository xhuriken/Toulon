using UnityEngine;

public class PlayerCam : MonoBehaviour
{
    public float sensX = 400f;
    public float sensY = 400f;

    public Transform orientation;

    float xRotation;
    float yRotation;

    public float minY = -80f;
    public float maxY = 80f;


    public float XRotation => xRotation;

    void Start()
    {
        Cursor.lockState = CursorLockMode.Locked;
        Cursor.visible = false;
    }

    void Update()
    {
        float mouseX = Input.GetAxisRaw("Mouse X") * sensX * Time.deltaTime;
        float mouseY = Input.GetAxisRaw("Mouse Y") * sensY * Time.deltaTime;

        yRotation += mouseX;

        xRotation -= mouseY;
        xRotation = Mathf.Clamp(xRotation, minY, maxY);

        transform.rotation = Quaternion.Euler(xRotation, yRotation, 0);
        orientation.rotation = Quaternion.Euler(0, yRotation, 0);
    }
}
