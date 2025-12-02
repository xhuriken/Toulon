using System.Collections;
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
    float hitInput;

    private bool canCombo = false; 
    private bool hitQueued = false;

    private bool reversing = false;

    public Animator an;

    void Start()
    {
        an = GetComponent<Animator>();
        idlePos = transform.localPosition;
        idleRot = transform.localRotation;
    }

    private void Update()
    {
        MyInput();

       
        if (hitInput == 1f && !an.GetCurrentAnimatorStateInfo(0).IsName("HammerHit"))
        {
            an.SetTrigger("Hit");

            Debug.Log("Hit");
        }

   
    


        //if (hitInput == 1f && canCombo)
        //{
        //    hitQueued = true;
        //    Debug.Log("hitqueud");
        //}
    }

    //private void EnableCombo()
    //{
    //    canCombo = true;       
    //    hitQueued = false;
    //    Debug.Log("CanCombo");
    //}

    //private void CheckCombo()
    //{
    //    Debug.Log("chkcombo");
    //    if (hitQueued)
    //    {
    //        an.SetTrigger("Hit2");
    //        Debug.Log("Hit2");
    //    }


    //    canCombo = false;
    //    hitQueued = false;
    //}

    private void OnCollisionEnter(Collision collision)
    {
        if (collision.gameObject.CompareTag("Ground"))
        {
            an.speed = 0f; // stop animation
            StartCoroutine(ReverseAfterDelay(0.5f));
        }
    }

    private IEnumerator ReverseAfterDelay(float delay)
    {
        reversing = true;

        yield return new WaitForSeconds(delay);

       
        an.speed = 1f;
        Debug.Log("reverse");

        reversing = false;
    }



    private void MyInput()
    {
        hitInput = Input.GetMouseButtonDown(0) ? 1f : 0f;
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
