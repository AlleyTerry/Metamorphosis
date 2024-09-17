extends Label

@onready var letterArray = ["y","u","i","o","p","h","j","k","l","b","n","m"]
var currentLetter = 0
var letterToPress = ""
@export var testPass = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	letterToPress = letterArray[0]
	$".".text = "press and hold: q w e r"
	
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#StepThrough()
	#StepThroughConinuous()
	#if (Input.is_action_pressed("click")):
	#StepThroughHoldPress()
	$timerProgress.value = $Timer.time_left
	

func StepThrough():
	if (Input.is_action_just_pressed(letterToPress)):
		var tween = create_tween()
		$Timer.start()
		if currentLetter < 5:
			letterToPress = letterArray[currentLetter]
			$".".text = letterArray[currentLetter + 1]
			letterToPress = letterArray[currentLetter + 1]
			print(letterToPress)
			currentLetter += 1
			tween.tween_property($TextureProgressBar,"value", $TextureProgressBar.value + 25, 0.5)
			$Timer.start()
		else:
			tween.tween_property($TextureProgressBar,"value", $TextureProgressBar.value + 25, 0.5)
			$".".text = "congrats you know your abcs"
func StepThroughConinuous():
	if (Input.is_action_pressed(letterArray[0])):
		$".".text = letterArray[1]
		if (Input.is_action_pressed(letterArray[1])):
			$".".text = letterArray[2]
			if (Input.is_action_pressed(letterArray[2])):
				$".".text = letterArray[3]
				if (Input.is_action_pressed(letterArray[3])):
					var tween = create_tween()
					tween.tween_property($TextureProgressBar,"value", $TextureProgressBar.value + 100, 0.5)
	if ($TextureProgressBar.value >= 100):
					$".".text = "congrats you know your abcs"

	
	
