class_name Player extends CharacterBody2D

var canMove = true
var lockMovement = false
#setting up constant variables so you dont have to write 800 every time not public
@export var ACCELERATION = 100
const FRICTION = 10000
const MAX_SPEED = 100

#getting our aniamtion tree
enum {IDLE, RUN}
var state = IDLE
@onready var animation_player: AnimationPlayer = $AnimationPlayer
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

func _ready() -> void:
	DoorManager.onTriggerPlayerSpawn.connect(onSpawn)
	

func onSpawn(position: Vector2, direction: String):
	print("you are in the onSpawn Function")
	global_position = position


func _physics_process(delta):
	if canMove == true:
		move(delta)
		animate()
	if canMove == false:
		state = IDLE
		animate()
	jump()

func jump():
	if Input.is_action_just_pressed("jump"):
		var tween =  create_tween()
		tween.tween_property($".", 'position:y', $".".position.y -300 , 0.5)
		tween.tween_property($".", 'position:y', $".".position.y, 0.5)
		pass

func move(delta):
	var inputVector = Input.get_vector("LeftAction","RightAction","UpAction","DownAction")
	#print(inputVector)
	#if we are not moving
	if inputVector == Vector2.ZERO:
		state = IDLE
		applyFriction(FRICTION)
	else: #we are moving
		#state = IDLE
		#await get_tree().create_timer(0.2).timeout
		state = RUN
		applyMovement(inputVector * ACCELERATION)
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
