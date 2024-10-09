extends Node2D

@export var enemy: Resource = null
@export var playerHealth = 3
@onready var letterArray = ["Left","Right","Up","Down"]
var currentLetter = 0
var letterToPress = ""
@export var testPass = false
@export var startMinigame = false
var enemyTurnCheck = false
var defenseCheck = false
var newRandomLetter = ""
var timerCheck = true
var bossName = ""
var newArgument = "startDialogue"
var currentDialogue = bossName + "StartDialogue"
var inputCheck = false
@onready var tempVelocity = $Imeris2.ACCELERATION


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Dialogic.signal_event.connect(OnDialogicSignal)
	Dialogic.signal_event.connect(AttackSignal)
	Dialogic.signal_event.connect(EnemySignal)
	Dialogic.signal_event.connect(_endDialogue)
	Dialogic.signal_event.connect(_startDialogue)
	Dialogic.signal_event.connect(_giveVelocityBack)
	Dialogic.signal_event.connect(enemyAttack1)
	$Node2D.visible = true
	enemy.health = 3
	$Enemy/Sprite2D.texture = enemy.texture
	bossName = enemy.bossName
	print(bossName)
	letterToPress = letterArray[0]
	$letterShower.text = "press and hold: w a d"
	currentDialogue = bossName + "StartDialogue"
	var dialog = Dialogic.start(currentDialogue)
	dialog.process_mode= Node.PROCESS_MODE_ALWAYS
	Dialogic.process_mode = Node.PROCESS_MODE_ALWAYS
	
	
	
func enemyAttack1(argument: String):
	if argument == "enemyAttack1":
		print("this is enemy attack function")
		newRandomLetter = letterArray.pick_random()
		defenseCheck = true
		timerCheck = true
		enemyTurn()


func _startDialogue(argument: String):
	
	if argument == "startDialogue":

		get_tree().paused = true

		

func _endDialogue(argument: String):
	if argument == "endDialogue":
		get_tree().paused = false
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if defenseCheck == true:
		DefenseQTE()
	if (startMinigame == true):
		doMinigame()
	
	$letterShower/timerProgress.value = $letterShower/Timer.get_process_delta_time()
	$EnemyQTE/EnemyTimerProgress.value = $EnemyQTE/EnemyTimer.time_left

func _physics_process(delta: float) -> void:
	pass
	
	
func enemyTurn():
	enemyTurnCheck = false
	$EnemyQTE/EnemyTimer.stop()
	$EnemyQTE.visible = false
	#playerHealth -= 1
	#print("player health ", playerHealth)
	#$EnemyAnimationPlayer.play("EnemyAttack")
	var tweenPosition = $Enemy.position.y
	var tween = create_tween()
	tween.tween_property($Enemy, 'position:y', $Imeris2.position.y, 0.5)
	tween.tween_property($Enemy, 'position:y', tweenPosition, 0.5)
	#$AnimationPlayer.play("enemy_attack")
	#await $EnemyAnimationPlayer.animation_finished
	
	

func OnDialogicSignal(argument: String):
	#remember to pause dialogue
	if argument == "startBattle":
		print("signal was fired")
		$Imeris2.ACCELERATION = 0
		var dialog = Dialogic.start(bossName + "Round1")
		dialog.process_mode= Node.PROCESS_MODE_ALWAYS
		Dialogic.process_mode = Node.PROCESS_MODE_ALWAYS
	

func DefenseQTE():
	$EnemyQTE.visible = true
	# if (Input.is_action_pressed("s")):
	$EnemyQTE.text = newRandomLetter
	if timerCheck == true:
		$EnemyQTE/EnemyTimer.start()
		timerCheck = false
	#$EnemyQTE.text = newRandomLetter
	if (Input.is_action_pressed(newRandomLetter+"Action")):
		$EnemyQTE/EnemyTimer.stop()
		enemyTurnCheck = false
		defenseCheck = false
		$EnemyQTE.text = "MISS"
		await get_tree().create_timer(1).timeout
		$EnemyQTE.visible = false
		$Node2D.visible = true
		var dialog = Dialogic.start(bossName + "Round" + (str(Dialogic.VAR.currentRound)))
		dialog.process_mode= Node.PROCESS_MODE_ALWAYS
		Dialogic.process_mode = Node.PROCESS_MODE_ALWAYS

		
		

func AttackSignal(argument: String):
	if argument == "AttackChoice":
		$Node2D.visible = false
		$letterShower/TextureProgressBar.value = 0
		startMinigame = true

func EnemySignal(argument: String):
	if argument == "EnemyTurn":
		newRandomLetter = letterArray.pick_random()
		$Node2D.visible = false
		$letterShower/TextureProgressBar.value = 0
		enemyTurn()
		timerCheck = true
		defenseCheck = true
	

func _on_attack_button_pressed() -> void:
	$Node2D.visible = false
	$letterShower/TextureProgressBar.value = 0
	startMinigame = true
	
	

func PlayerAttack():
	if (testPass == true):
		$Imeris2/PlayerAttack.visible = true
		$letterShower.visible = false
		testPass = false
		enemy.health -= 1
		print("enemy health ", enemy.health)
		var tweenPosition = $Imeris2/PlayerAttack/Sprite2D.position.y
		var tween = create_tween()
		tween.tween_property($Imeris2/PlayerAttack, 'position:y',  -$Enemy.position.y, 0.5)
		tween.tween_property($Imeris2/PlayerAttack/Sprite2D, 'position:y', tweenPosition, 0.5)
		$AnimationPlayer.play("EnemyHurt")
		await $AnimationPlayer.animation_finished
		print(enemy.health)
		$Imeris2/PlayerAttack.visible = false
		if (enemy.health <= 0):
			$AnimationPlayer.play("EnemyDied")
			await $AnimationPlayer.animation_finished
			await get_tree().create_timer(.25).timeout
		else:
			newRandomLetter = letterArray.pick_random()
			defenseCheck = true
			timerCheck = true
			enemyTurn()

	
func doMinigame():
	inputCheck = true
	$letterShower.visible =  true
	if inputCheck == true:
		while (Input.is_action_pressed("w") && Input.is_action_pressed("a") && Input.is_action_pressed("d")):
			$letterShower.text = letterToPress
			StepThrough()
			if ($letterShower/TextureProgressBar.value >= 100):
				testPass = true
				TurnReset()
				PlayerAttack()
			break
	
	

func StepThrough():
	if (Input.is_action_just_pressed(letterToPress + "Action")):
		$letterShower.visible = false
		await get_tree().create_timer(.1).timeout
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
			$letterShower.visible = true
		else:
			tween.tween_property($letterShower/TextureProgressBar,"value", $letterShower/TextureProgressBar.value + 20, 0.5)




func _on_timer_timeout() -> void:
	inputCheck = false
	$letterShower.text = "MISS"
	$Imeris2.ACCELERATION += $Imeris2.ACCELERATION
	await get_tree().create_timer(.5).timeout
	TurnReset()
	newRandomLetter = letterArray.pick_random()
	defenseCheck = true
	timerCheck = true
	enemyTurn()
	
	
func TurnReset():
	startMinigame = false
	$EnemyQTE.visible = false
	$letterShower/TextureProgressBar.value = 0
	currentLetter = 0
	$letterShower/Timer.stop()
	$letterShower.text = "press and hold: w a d "
	$letterShower.visible = false
	




func _on_enemy_timer_timeout() -> void:
	defenseCheck = false
	$EnemyQTE/EnemyTimer.stop()
	$AnimationPlayer.play("PlayerHurt")
	await $AnimationPlayer.animation_finished
	playerHealth -= 1
	print("player health ", playerHealth)
	TurnReset()
	$Node2D.visible = true
	var dialog = Dialogic.start(bossName + "Round" + (str(Dialogic.VAR.currentRound)))
	dialog.process_mode= Node.PROCESS_MODE_ALWAYS
	Dialogic.process_mode = Node.PROCESS_MODE_ALWAYS




func _on_player_area_area_entered(area: Area2D) -> void:
	if area.name == "EnemyArea":
		defenseCheck = true
		print(area.name)


func _on_headless_area_area_entered(area: Area2D) -> void:
	if area.name == "PlayerArea":
		print("u are in the correct area")
		currentDialogue = "Boss1AreaSignal"
		var dialog = Dialogic.start(currentDialogue)
		dialog.process_mode= Node.PROCESS_MODE_ALWAYS
		Dialogic.process_mode = Node.PROCESS_MODE_ALWAYS
	
	


func _on_headless_area_2_area_entered(area: Area2D) -> void:
	if area.name == "PlayerArea":
		print("u are in the correct area... again")
		currentDialogue = "Boss1AreaSignal2"
		var dialog = Dialogic.start(currentDialogue)
		dialog.process_mode= Node.PROCESS_MODE_ALWAYS
		Dialogic.process_mode = Node.PROCESS_MODE_ALWAYS

func _giveVelocityBack(argument):
	if argument == "velocity":
		$Imeris2.ACCELERATION += tempVelocity
