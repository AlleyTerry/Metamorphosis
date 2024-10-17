extends Node

const sceneImerisRoom = preload("res://Scenes/ImerisRoom.tscn")
const sceneHallway = preload("res://Scenes/Hallway.tscn")
#const sceneCafeteria =
const sceneChapel = preload("res://Scenes/battle_scene.tscn")
#const sceneMainHall = 
#const sceneServentTunnel = 

signal onTriggerPlayerSpawn

var spawnTag

func goToLevel(levelTag, destinationTag):
	var sceneToLoad
	
	match levelTag:
		"ImerisRoom":
			sceneToLoad = sceneImerisRoom
		"Hallway":
			sceneToLoad = sceneHallway
		"Chapel":
			sceneToLoad = sceneChapel
		#"Cafeteria":
			#sceneToLoad = sceneCafeteria
		
		
		
	if sceneToLoad != null:
		spawnTag = destinationTag
		get_tree().change_scene_to_packed(sceneToLoad)
		
func triggerPlayerSpawn(position: Vector2,direction: String):
	onTriggerPlayerSpawn.emit(position, direction)
	
