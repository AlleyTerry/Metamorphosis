using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Jumping : MonoBehaviour
{
    public bool isEvolved = false;
    
    public float jumpHeight = 2f; // Aimed jump height
    public float jumpSpeed = 5f;  // Jump speed
    
    [SerializeField] private bool isJumping = false; // Flag if the player is jumping, prevent repeated triggering jumping
    [SerializeField] private bool isAscending = true; // If the player is ascending, going up
    private float originalY; // The original Y position when the player hit space
    private float targetY; // If the player reaches the target jumping Y position, start descending

    public GameObject sprite;
    
    public bool isLaddering = false;
    
    private void Start()
    {
        originalY = transform.position.y; // Initialize the original Y position

        //sprite = gameObject;
        //sprite = transform.GetChild(0).gameObject;
    }

    void Update()
    {
        // When the player hit space and is not jumping
        if (Input.GetButtonDown("Jump") && !isJumping)
        {
            StartJump();
        }

        // The real jump logic
        if (isJumping)
        {
            HandleJump();
        }

        if (isEvolved)
        {
            jumpHeight = 4.5f;
        }
        else
        {
            jumpHeight = 1.0f;
        }
    }

    private void StartJump()
    {
        isJumping = true;
        isAscending = true; // Flag the player is ascending
        
        originalY = transform.position.y; // Record the original Y position
        targetY = originalY + jumpHeight; // Calculate the target Y position
        
        GetComponent<Rigidbody>().useGravity = false; // Disable gravity when jumping
    }

    private void HandleJump()
    {
        // The player is ascending
        if (isAscending)
        {
            transform.position += new Vector3(0, jumpSpeed * Time.deltaTime, 0); // Move the player up

            // When the player reach the target Y position, start descending
            if (transform.position.y >= targetY) // The player reach the target Y position
            {
                isAscending = false; // Flag the player is descending
            }
        }
        // The player is descending 
        else
        {
            transform.position -= new Vector3(0, jumpSpeed * Time.deltaTime, 0); // Move the player down

            // When the player reach the original Y position, stop moving
            if (transform.position.y <= originalY)
            {
                isJumping = false;
                transform.position = new Vector3(transform.position.x, originalY, transform.position.z); // Make sure the player is at the original Y position
                GetComponent<Rigidbody>().useGravity = true; // Enable gravity
            }
        }
    }

    private void OnCollisionEnter(Collision other)
    {
        if (other.transform.CompareTag("Blocker"))
        {
            isJumping = false;
            originalY = transform.position.y;
            transform.position = new Vector3(transform.position.x, originalY, transform.position.z);
            GetComponent<Rigidbody>().useGravity = true; // Enable gravity
        }
    }

    private void OnTriggerEnter(Collider other)
    {
        if (other.transform.CompareTag("Ladder"))
        {
            Debug.Log("Collided with Ladder");
            isLaddering = true;
        }
    }
    
    private void OnTriggerStay(Collider other)
    {
        if (other.transform.CompareTag("Ladder"))
        {
            Debug.Log("Collided with Ladder");
            isLaddering = true;
        }
    }
    
    private void OnTriggerExit(Collider other)
    {
        if (other.transform.CompareTag("Ladder"))
        {
            Debug.Log("Exit Ladder");
            isLaddering = false;
        }
    }
}
