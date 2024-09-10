extends Label

@onready var letterArray = ["a","b","c","d"]
var currentLetter = 0
var letterToPress = ""

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	letterToPress = letterArray[0]
	$".".text = "press and hold: q w e r"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#StepThrough()
	#StepThroughConinuous()
	StepThroughHoldPress()

func StepThrough():
	if (Input.is_action_pressed(letterToPress)):
		var tween = create_tween()
		if currentLetter < letterArray.size()-1:
			letterToPress = letterArray[currentLetter]
			$".".text = letterArray[currentLetter + 1]
			letterToPress = letterArray[currentLetter + 1]
			print(letterToPress)
			currentLetter += 1
			tween.tween_property($TextureProgressBar,"value", $TextureProgressBar.value + 25, 0.5)
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
func StepThroughHoldPress():
	while (Input.is_action_pressed("w") && Input.is_action_pressed("e") && Input.is_action_pressed("q") && Input.is_action_pressed("r")):
		$".".text = letterToPress
		StepThrough()
		if ($TextureProgressBar.value >= 100):
			$".".text = "ur a wizard wrow..."
		break
