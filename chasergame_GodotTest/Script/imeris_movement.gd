extends CharacterBody2D

#setting up constant variables so you dont have to write 800 every time not public
@export var ACCELERATION = 100
const FRICTION = 1000000
const MAX_SPEED = 100

#getting our aniamtion tree
enum {IDLE, RUN}
var state = IDLE

@onready var animationTree = $AnimationTree
@onready var stateMachine = animationTree["parameters/playback"]

#only seeting blend position when we move
var blendPoition : Vector2 = Vector2.ZERO
#take in paths to blend positions idle being the first item in array
var blendPosPaths =[
"parameters/idle/idl_bs2D/blend_position", 
"parameters/run/run_bs2D/blend_position"
]
var animTreeStateKeys = ["idle", "run"]



func _physics_process(delta):
	move(delta)
	animate()

func move(delta):
	var inputVector = Input.get_vector("move_left","move_right","move_up","move_down")
	#if we are not moving
	if inputVector == Vector2.ZERO:
		animationTree.set(blendPosPaths[state], blendPoition)
		applyFriction(FRICTION * delta)
	else: #we are moving
		state = RUN
		applyMovement(inputVector * ACCELERATION * delta)
		blendPoition = inputVector
	move_and_slide()
	
#apply friction
func applyFriction(amount) -> void:
	if velocity.length() > amount:
		velocity -= velocity.normalized() * amount
	else:
		velocity = Vector2.ZERO
		
#apply movement
func applyMovement(amount) -> void:
	velocity += amount
	velocity = velocity.limit_length(MAX_SPEED)
	
	
#animate our player
func animate() -> void:
	stateMachine.travel(animTreeStateKeys[state])
	animationTree.set(blendPosPaths[state], blendPoition)
