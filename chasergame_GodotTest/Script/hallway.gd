extends Node2D

func _ready() -> void:
	if DoorManager.spawnTag != null:
		onleveSpawn(DoorManager.spawnTag)

func onleveSpawn(destinationTag: String):
	var door_path = "Doors/Door_" + destinationTag
	var door = get_node(door_path) as Door
	DoorManager.triggerPlayerSpawn(door.spawn.global_position, door.spawnDirection)
