extends Node2D

var currentDialogue = ""

func _ready() -> void:
	if DoorManager.spawnTag != null:
		onleveSpawn(DoorManager.spawnTag)
	
	Dialogic.signal_event.connect(_endDialogue)
	Dialogic.signal_event.connect(_startDialogue)
	Dialogic.signal_event.connect(moveDresser)
	$ViewportOverlay/AnimationPlayer.play("smallImeris")
	currentDialogue = "ImerisRoomDialogue"
	var dialog = Dialogic.start(currentDialogue)
	dialog.process_mode= Node.PROCESS_MODE_ALWAYS
	Dialogic.process_mode = Node.PROCESS_MODE_ALWAYS

func onleveSpawn(destinationTag: String):
	var door_path = "Doors/Door_" + destinationTag
	var door = get_node(door_path) as Door
	DoorManager.triggerPlayerSpawn(door.spawn.global_position, door.spawnDirection)
	

func moveDresser (argument: String):
	if argument == "moveDresser":
		var tween = create_tween()
		tween.tween_property($Dresser, 'position:y', 268, 0.5)

func _startDialogue(argument: String):
	if argument == "startDialogue":
		$Imeris.canMove = false
		#get_tree().paused = true


func _endDialogue(argument: String):
	if argument == "endDialogue":
		$Imeris.canMove = true
		#get_tree().paused = false
