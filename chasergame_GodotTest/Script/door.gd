extends Area2D

class_name Door

@export var  destinationScene =  ""
@export var destinationDoor =  ""
@export var spawnDirection =  "up"

@onready var spawn = $Spawn




func _on_area_entered(area: Area2D) -> void:
	if area.name == "PlayerArea":
		print("hey this is a door")
		DoorManager.goToLevel(destinationScene, destinationDoor)
