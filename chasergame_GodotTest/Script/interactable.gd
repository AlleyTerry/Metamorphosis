extends Node2D

@export var imerisHolder = Node2D
var tempVelocity = 0
var player_in_area = false
@export var currentDialogue = ""

func _ready():
	tempVelocity = imerisHolder.ACCELERATION



	
func _physics_process(delta):
	if Input.is_action_just_pressed("interact") && player_in_area == true:
		playText()
		


func _on_dialogic_signal(argument: String):
	if argument == "end":
		print("ended")
		imerisHolder.canMove = true




func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.name == "PlayerArea":
		print("you are in the area")
		player_in_area = true


func playText():
	Dialogic.signal_event.connect(_on_dialogic_signal)
	var dialog = Dialogic.start(currentDialogue)
	dialog.process_mode = Node.PROCESS_MODE_ALWAYS
	Dialogic.process_mode = Node.PROCESS_MODE_ALWAYS
	imerisHolder.canMove = false

		

func _on_area_2d_area_exited(area: Area2D) -> void:
		if area.name == "PlayerArea":
			player_in_area = false
			
