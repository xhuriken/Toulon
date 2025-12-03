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

    public Transform playerCamera;
    public float requiredLookAngle = 40f;

    public float hammerBounceForce = 12f;
    public Rigidbody playerRb;
    public float minHeightForHitDown = 2f;

    public Animator an;
    public AudioSource audioSource;
    public PlayerMovement playerMovement;

    public string hitDownAnimName = "HammerDown";
    void Start()
    {
        an = GetComponent<Animator>();
        audioSource = GetComponent<AudioSource>();
        idlePos = transform.localPosition;
        idleRot = transform.localRotation;
    }

    private void Update()
    {
        hitInput = Input.GetMouseButton(0) ? 1f : 0f;
        bool isHitDown = an.GetCurrentAnimatorStateInfo(0).IsName(hitDownAnimName);
 
        if (hitInput == 1f)
        {
            if (!playerMovement.grounded && transform.position.y >= minHeightForHitDown)
            {
                an.SetTrigger("HitDown");
                an.speed = 0f;
                
            }

            else
            {
                if (!an.GetCurrentAnimatorStateInfo(0).IsName("HammerHit") && !isHitDown)
                {
                    an.SetTrigger("Hit");
                }
            }

         
        }
      
        if (isHitDown && playerMovement.grounded)
        {
            an.speed = 1f;
        }

        
    }

    public void jump()
    {
        bool isHitDown = an.GetCurrentAnimatorStateInfo(0).IsName(hitDownAnimName);
        if (IsLookingDown() && !isHitDown)
        {
            Debug.Log("boing");
            playerRb.AddForce(Vector3.up * hammerBounceForce, ForceMode.Impulse);
        }
    }

    public void PlaySound(AudioClip clip)
    {
      
       audioSource.PlayOneShot(clip);
    }


    private bool IsLookingDown()
    { 
        float pitch = playerCamera.localEulerAngles.x;

        if (pitch > 180f)
            pitch -= 360f;

        return pitch > requiredLookAngle;
    }


}
