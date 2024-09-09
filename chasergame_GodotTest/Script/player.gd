extends CharacterBody2D

class_name Bird

@export var gravity = 900.0
@export var jumpForce = -300.0
@export var maxSpeed = 400.0

func _ready() -> void:
	#velocity is a built in variable for chracter body 2D
	velocity = Vector2.ZERO
	

func _physics_process(delta: float) -> void:
	if (Input.is_action_pressed("click")):
		jump()
	
	velocity.y += gravity * delta
	
	velocity.y = min(velocity.y, maxSpeed)
	move_and_collide((velocity * delta))

func jump():
	velocity.y = jumpForce
	
