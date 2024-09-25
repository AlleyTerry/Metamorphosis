extends CharacterBody2D

const SPEED = 350.0
const ACCELERATION = 1200.0
const FRICTION = 1400.0

const GRAVITY = 2000.0
const FALL_GRAVITY = 3000.0
const FAST_FALL_GRAVITY = 5000.0
const WALL_GRAVITY = 25.0

const JUMP_VELOCITY = -700.0
const WALL_JUMP_VELOCITY = -700.0
const WALL_JUMP_PUSHBACK = 300.0

const INPUT_BUFFER_PATIENCE = 0.1
const COYOTE_TIME = 0.08

var inputBuffer : Timer
var coyoteTimer : Timer
var coyoteJumpAvailable = true

var jumpTimes = 0
var jumpMax = 3


func _ready() -> void:
	#set up input buffer timer
	inputBuffer = Timer.new()
	inputBuffer.wait_time = INPUT_BUFFER_PATIENCE
	inputBuffer.one_shot = true
	add_child((inputBuffer))
	
	#set up cayote timer
	coyoteTimer = Timer.new()
	coyoteTimer.wait_time = COYOTE_TIME
	coyoteTimer.one_shot = true
	add_child(coyoteTimer)
	coyoteTimer.timeout.connect(CoyoteTimeout)
	

func _physics_process(delta: float) -> void:
	var horizontalInput = Input.get_axis("move_left","move_right")
	var jump_attempted = Input.is_action_just_pressed("jump")
	
	#gives leeeway for player incase they are not completely on the ground
	#handle jumping
	if (jump_attempted or inputBuffer.time_left > 0):
		if !is_on_floor() and jumpTimes < jumpMax:
			velocity.y = JUMP_VELOCITY
		if coyoteJumpAvailable:
			velocity.y = JUMP_VELOCITY
			coyoteJumpAvailable = false
		elif (is_on_wall() and horizontalInput != 0):
			velocity.y = WALL_JUMP_VELOCITY
			#value for pushing off the wall based on your horizontal input
			velocity.x = WALL_JUMP_PUSHBACK * -sign(horizontalInput)
		elif jump_attempted:
			#jump did not happen
			inputBuffer.start()
	#the longer you hold the jump key the higher you jump
	if Input.is_action_just_released("jump") and velocity.y < 0:
		velocity.y = JUMP_VELOCITY / 4
		jumpTimes += 1
	
		
	#apply gravity
	if is_on_floor():
		coyoteJumpAvailable = true
		coyoteTimer.stop()
		jumpTimes = 0
	else:
		if coyoteJumpAvailable:
			if coyoteTimer.is_stopped():
				coyoteTimer.start()
		velocity.y += get_grav(horizontalInput) * delta
	
	#horizontal movement
	var floorDamping : float = 1.0 if is_on_floor() else 0.2
	var dashMultiplyer : float = 2.0 if Input.is_action_pressed("dash") else 1.0
	if horizontalInput:
		velocity.x = move_toward(velocity.x, horizontalInput * SPEED * dashMultiplyer, ACCELERATION *delta)
	else:
		velocity.x = move_toward(velocity.x, 0, (FRICTION * delta) * floorDamping)
	
	move_and_slide()
	

#different gravity based on the current state of the player
func get_grav(input_dir : float = 0) -> float:
	if Input.is_action_just_pressed("fast_fall"):
		return FAST_FALL_GRAVITY
	if is_on_wall_only() and velocity.y > 0 and input_dir != 0:
		return WALL_GRAVITY
	return GRAVITY if velocity.y < 0 else FALL_GRAVITY

func CoyoteTimeout():
	coyoteJumpAvailable = false
