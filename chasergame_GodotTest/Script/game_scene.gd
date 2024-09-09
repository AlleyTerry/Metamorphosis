extends Node2D

var gameDone = false
var gameTimes = 0
@onready var noderef = $StarPosition/star


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (gameDone == false):
		if (len($star/Area2D.get_overlapping_areas()) > 0):
			$TextureProgressBar.value += 30 * delta
			if ($TextureProgressBar.value >= 100):
				Caught()
				newFish()
		else:
			$TextureProgressBar.value -= 30 * delta
			if ($TextureProgressBar.value <= 0):
				$TextureProgressBar.value = 0
			

func Caught():
	$EndGameMessage.text = "you got the fish!"
	$TextureProgressBar.value = 0
	gameTimes += 1
	gameDone = true

func newFish():
	if gameTimes <= 3:
		#get_node("star").newTime()
		gameDone = false
	else:
		$EndGameMessage.text = "ripppp"
		get_node("star").destroy()
		
	
	
