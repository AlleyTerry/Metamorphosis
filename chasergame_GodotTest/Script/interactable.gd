extends Node2D

@export var imerisHolder = Node2D
var tempVelocity = 0
var player_in_area = false
@export var currentDialogue = ""
var isPlaying = true
var isDialogue = false

func _ready():
	pass



func _physics_process(delta):
	if Input.is_action_just_pressed("interact") && player_in_area == true && isPlaying == true:
		Dialogic.signal_event.connect(_endDialogue)
		Dialogic.signal_event.connect(_startDialogue)
		playText()
	if Dialogic.Text.is_textbox_visible():
		isPlaying = false
	else:
		isPlaying = true

	

		

func _startDialogue(argument: String):
	if argument == "startDialogue":
		imerisHolder.canMove = false
		print("start")


func _endDialogue(argument: String):
	if argument == "endDialogue":
		imerisHolder.canMove = true
		print("end")
		Dialogic.signal_event.disconnect(_endDialogue)
		Dialogic.signal_event.disconnect(_startDialogue)
		



func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.name == "PlayerArea":
		print("you are in the area")
		player_in_area = true


func playText():
	var dialog = Dialogic.start(currentDialogue)
	dialog.process_mode = Node.PROCESS_MODE_ALWAYS
	Dialogic.process_mode = Node.PROCESS_MODE_ALWAYS
	#isPlaying = true

		

func _on_area_2d_area_exited(area: Area2D) -> void:
		if area.name == "PlayerArea":
			player_in_area = false
			
