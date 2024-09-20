extends Node2D

@export var enemy: Resource = null
@export var playerHealth = 3
@onready var letterArray = ["y","u","i","o","p","h","j","k","l","b","n","m"]
var currentLetter = 0
var letterToPress = ""
@export var testPass = false
@export var startMinigame = false
var enemyTurnCheck = false
var defenseCheck = false
var newRandomLetter = ""
var timerCheck = true


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Node2D.visible = true
	enemy.health = 3
	$Enemy/CollisionShape2D/Sprite2D.texture = enemy.texture
	letterToPress = letterArray[0]
	$letterShower.text = "press and hold: q w e r"
	newRandomLetter = letterArray.pick_random()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (startMinigame == true):
		doMinigame()
	if (defenseCheck == true):
		DefenseQTE()
	$letterShower/timerProgress.value = $letterShower/Timer.get_process_delta_time()
	$EnemyQTE/EnemyTimerProgress.value = $EnemyQTE/EnemyTimer.time_left
	
	
func enemyTurn():
	enemyTurnCheck = false
	$EnemyQTE/EnemyTimer.stop()
	$EnemyQTE.visible = false
	playerHealth -= 1
	print("player health ", playerHealth)
	$AnimationPlayer.play("enemy_attack")
	await $AnimationPlayer.animation_finished
	$AnimationPlayer.play("PlayerHurt")
	await $AnimationPlayer.animation_finished
	$Node2D.visible = true
	if playerHealth <= 0:
		$EnemyQTE.visible = false
		$EnemyQTE.text = "U DEAD"
	else:
		defenseCheck = false
		enemyTurnCheck = false
		TurnReset()
	



func DefenseQTE():
	$EnemyQTE.visible = true
	if (Input.is_action_pressed("s")):
		$EnemyQTE.text = newRandomLetter
		if timerCheck == true:
			$EnemyQTE/EnemyTimer.start()
			timerCheck = false
		$EnemyQTE.text = newRandomLetter
		if (Input.is_action_just_pressed(newRandomLetter)):
			$EnemyQTE/EnemyTimer.stop()
			enemyTurnCheck = false
			defenseCheck = false
			$EnemyQTE.text = "MISS"
			await get_tree().create_timer(1).timeout
			$EnemyQTE.visible = false
			$Node2D.visible = true
		elif enemyTurnCheck == true:
			defenseCheck = false
			$EnemyQTE/EnemyTimer.stop()
			$EnemyQTE.visible = false
			enemyTurn()

func _on_attack_button_pressed() -> void:
	$Node2D.visible = false
	$letterShower/TextureProgressBar.value = 0
	startMinigame = true
	
	

func PlayerAttack():
	if (testPass == true):
		$letterShower.visible = false
		testPass = false
		enemy.health -= 1
		print("enemy health ", enemy.health)
		$AnimationPlayer.play("player_attack")
		await $AnimationPlayer.animation_finished
		$AnimationPlayer.play("EnemyHurt")
		await $AnimationPlayer.animation_finished
		print(enemy.health)
		if (enemy.health <= 0):
			$AnimationPlayer.play("EnemyDied")
			await $AnimationPlayer.animation_finished
			await get_tree().create_timer(.25).timeout
			get_tree().change_scene_to_file("res://Scenes/game_scene.tscn")
		else:
			defenseCheck = true
			$EnemyQTE.text = "hold s"
			timerCheck = true
			DefenseQTE()

	
func doMinigame():
	$letterShower.visible =  true
	while (Input.is_action_pressed("w") && Input.is_action_pressed("e") && Input.is_action_pressed("q") && Input.is_action_pressed("r")):
		$letterShower.text = letterToPress
		StepThrough()
		if ($letterShower/TextureProgressBar.value >= 100):
			testPass = true
			TurnReset()
			PlayerAttack()
		break
	

func StepThrough():
	if (Input.is_action_just_pressed(letterToPress)):
		var tween = create_tween()
		$letterShower/Timer.start()
		if currentLetter <= 3:
			var randomLetter = letterArray.pick_random()
			#letterToPress = letterArray[currentLetter]
			$letterShower.text = randomLetter
			letterToPress = randomLetter
			print(letterToPress)
			currentLetter += 1
			tween.tween_property($letterShower/TextureProgressBar,"value", $letterShower/TextureProgressBar.value + 20, 0.5)
			
		else:
			tween.tween_property($letterShower/TextureProgressBar,"value", $letterShower/TextureProgressBar.value + 20, 0.5)


func _on_talk_button_pressed() -> void:
	pass
	


func _on_timer_timeout() -> void:
	TurnReset()
	await get_tree().create_timer(.5).timeout
	defenseCheck = true
	timerCheck = true
	$EnemyQTE.text = "hold s"
	DefenseQTE()
	
func TurnReset():
	startMinigame = false
	$EnemyQTE.visible = false
	$letterShower/TextureProgressBar.value = 0
	currentLetter = 0
	$letterShower/Timer.stop()
	$letterShower.text = "press and hold: q w e r"
	$letterShower.visible = false
	


func _on_enemy_timer_timeout() -> void:
	enemyTurn()
	
