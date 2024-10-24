extends Node2D

@onready var tempVelocity = $"../Imeris".ACCELERATION
var player_in_area = false
@export var currentDialogue = ""

func _ready():
	print(currentDialogue)




	
func _physics_process(delta):
	if Input.is_action_just_pressed("interact"):
		playText()
		


func _on_dialogic_signal(argument: String):
	if argument == "end":
		print("ended")
		$"../Imeris".ACCELERATION += tempVelocity




func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.name == "PlayerArea":
		print("you are in the area")
		player_in_area = true


func playText():
	Dialogic.signal_event.connect(_on_dialogic_signal)
	var dialog = Dialogic.start(currentDialogue)
	dialog.process_mode= Node.PROCESS_MODE_ALWAYS
	Dialogic.process_mode = Node.PROCESS_MODE_ALWAYS
	$"../AudioStreamPlayer2D".process_mode = Node.PROCESS_MODE_ALWAYS
	$"../Imeris".ACCELERATION = 0
	


func _on_area_2d_area_exited(area: Area2D) -> void:
		if area.name == "PlayerArea":
			player_in_area = false
			
