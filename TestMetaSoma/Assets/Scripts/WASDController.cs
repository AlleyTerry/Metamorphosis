using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class WASDController : MonoBehaviour
{
    private float horizontalInput;
    private float verticalInput;
    [SerializeField] private float speed = 10.0f;
    [SerializeField] private float jumpForce = 10.0f;
    [SerializeField] private bool isFloating = false;
    
    [SerializeField] private Rigidbody rb;
    [SerializeField] private float gravityModifier = 2.0f;
    
    private Vector3 positionOrigin;
    
    public Jumping jumpScript;
    
    // Start is called before the first frame update
    void Start()
    {
        rb = GetComponent<Rigidbody>();
        
        //rb.useGravity = false;
        positionOrigin = transform.position;
        isFloating = false;
    }

    // Update is called once per frame
    void Update()
    {
        horizontalInput = Input.GetAxis("Horizontal");
        verticalInput = Input.GetAxis("Vertical");
        
        Controller();
    }

    void Controller()
    {
        rb.velocity = new Vector3(horizontalInput * speed, rb.velocity.y, rb.velocity.z);
        
        if (!jumpScript.isLaddering)
        {
            rb.velocity = new Vector3(rb.velocity.x,rb.velocity.y, verticalInput * speed);
        }
        else
        {
            rb.velocity = new Vector3(rb.velocity.x,verticalInput * speed, rb.velocity.z);
        }

        /*if (Input.GetKeyDown(KeyCode.Space) && !isFloating)
        {
            rb.velocity = new Vector3(rb.velocity.x, jumpForce, rb.velocity.z);
            positionOrigin = transform.position;
            //rb.useGravity = true;
            isFloating = true;
        }

        if (isFloating && rb.velocity.y < 0)
        {
            rb.velocity += Vector3.up * Physics.gravity.y * gravityModifier * Time.deltaTime;
        }
        
        if (isFloating && transform.position.y < positionOrigin.y)
        {
            /*rb.useGravity = false;#1#
            rb.velocity = new Vector3(rb.velocity.x, 0.0f, rb.velocity.z);
            transform.position = new Vector3(transform.position.x, positionOrigin.y, transform.position.z);
            isFloating = false;
        }*/
    }
}
