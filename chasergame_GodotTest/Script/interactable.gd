extends Node2D

@export var imerisHolder = Node2D
var tempVelocity = 0
var player_in_area = false
@export var currentDialogue = ""
var isPlaying = true

func _ready():
	Dialogic.signal_event.connect(_endDialogue)
	Dialogic.signal_event.connect(_startDialogue)



	
func _physics_process(delta):
	if Input.is_action_just_pressed("interact") && player_in_area == true && isPlaying == true:
		playText()
		

func _startDialogue(argument: String):
	if argument == "startDialogue":
		imerisHolder.canMove = false
		#get_tree().paused = true


func _endDialogue(argument: String):
	if argument == "endDialogue":
		imerisHolder.canMove = false
		isPlaying = true
		#get_tree().paused = false



func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.name == "PlayerArea":
		print("you are in the area")
		player_in_area = true


func playText():
	isPlaying = false
	var dialog = Dialogic.start(currentDialogue)
	dialog.process_mode = Node.PROCESS_MODE_ALWAYS
	Dialogic.process_mode = Node.PROCESS_MODE_ALWAYS
	imerisHolder.canMove = false

		

func _on_area_2d_area_exited(area: Area2D) -> void:
		if area.name == "PlayerArea":
			player_in_area = false
			
