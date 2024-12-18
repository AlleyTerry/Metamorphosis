extends Node2D

#these are the variables for setting up the enemy resource and player health
@export var enemy: Resource = null
@export var playerHealth = 3
#array of the arrow key names and slots for number through the array
@onready var letterArray = ["Left","Right","Up","Down"]
var currentLetter = 0
var letterToPress = ""
#a bunch of checks i have to come back and see what they are for lol
@export var testPass = false
@export var startMinigame = false
var enemyTurnCheck = false
var defenseCheck = false
var newRandomLetter = ""
var timerCheck = true
#variables for dialogic to see what timeline to play
var bossName = ""
var newArgument = "startDialogue"
var currentDialogue = bossName + "StartDialogue"
#another check for input??? check later please
var inputCheck = false
#var for Imeris starting velocity because idk how else to stop movement
@onready var tempVelocity = $Imeris.ACCELERATION
#adds arrow nodes to a var to be able to be turned on and off
@export var tempArrow: Sprite2D
#var to check if you have done the hold wad for the first time
var firstCheck = true
var upCheck = false
@onready var tweenPosition = $Imeris.position.y
@onready var smokePosition = $Smoke2.position



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#$Smoke/CPUParticles2D.emitting = true
	$CanvasLayer/AnimatedSprite2D/AnimationPlayer.play("ImerisHungrySmall")
	#door set up when entering the room
	if DoorManager.spawnTag != null:
		onleveSpawn(DoorManager.spawnTag)
	#all of the signals that need to happen for dialogue to play
	Dialogic.signal_event.connect(AttackSignal)
	Dialogic.signal_event.connect(EnemySignal)
	Dialogic.signal_event.connect(_endDialogue)
	Dialogic.signal_event.connect(_startDialogue)
	Dialogic.signal_event.connect(_giveVelocityBack)
	Dialogic.signal_event.connect(enemyAttack1)
	Dialogic.signal_event.connect(moveUp)
	Dialogic.signal_event.connect(gameOver)
	Dialogic.signal_event.connect(endVelocity)
	#I wish i knew what node this is lmao i dont think it exists anymore
	$Node2D.visible = true
	#setting the values in the enemy resource
	enemy.health = 3
	$Enemy/Sprite2D.texture = enemy.texture
	bossName = enemy.bossName
	print(bossName)
	
	letterToPress = letterArray[0]
	$letterShower.text = "press w to move forward"
	#dialogic pause shit that doesnt work anymore for some reason
	currentDialogue = bossName + "StartDialogue"
	var dialog = Dialogic.start(currentDialogue)
	dialog.process_mode= Node.PROCESS_MODE_ALWAYS
	Dialogic.process_mode = Node.PROCESS_MODE_ALWAYS
	$AudioStreamPlayer2D.process_mode = Node.PROCESS_MODE_ALWAYS
	
#door functions
func onleveSpawn(destinationTag: String):
	var door_path = "Doors/Door_" + destinationTag
	var door = get_node(door_path) as Door
	DoorManager.triggerPlayerSpawn(door.spawn.global_position, door.spawnDirection)
	
#when you die this will take you to the game over scene
func gameOver (argument: String):
	if argument == "gameOver":
		get_tree().change_scene_to_file("res://Scenes/game_over.tscn")

#imeris will move up a certain amount when this is called
func moveUp(argument: String):
	if argument == "moveUp":
		var tween = create_tween()
		tween.tween_property($Imeris, 'position:y', $Imeris.position.y -50 , 0.5)
	
	
#when dialogic calls the enemy attack, it sets the defesnse qte checks to true
#picks a random arrow and then runs enemy turn
func enemyAttack1(argument: String):
	if argument == "enemyAttack1":
		print("this is enemy attack function")
		newRandomLetter = letterArray.pick_random()
		enemyTurn()

#start dialogue at the beginning
func _startDialogue(argument: String):
	if argument == "startDialogue":
		$Imeris.canMove = false
		#get_tree().paused = true

		
#ends the dialogue
func _endDialogue(argument: String):
	if argument == "endDialogue":
		$Imeris.canMove = true
		#get_tree().paused = false
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#because these checks are predicated on input they need to be in process
	#as long as they are true, you can do the minigame qtes
	if defenseCheck == true:
		DefenseQTE()
	if (startMinigame == true):
		doMinigame()
	
	#these are for the timers that the player does not see
	$letterShower/timerProgress.value = $letterShower/Timer.get_process_delta_time()
	$EnemyQTE/EnemyTimerProgress.value = $EnemyQTE/EnemyTimer.time_left

func _physics_process(delta: float) -> void:
	pass
	

# this is the enemy's turn
func enemyTurn():
	$Path2D/PathFollow2D.progress_ratio = 0
	#turns the check to false so after this is done it is no longet the enemy's turn
	enemyTurnCheck = false
	#the timer for the player's defense qte is stopped and turned off
	$EnemyQTE/EnemyTimer.stop()
	$EnemyQTE.visible = false
	#the first smoke starts emitting and does a circle around the player
	$Path2D/PathFollow2D/Smoke/CPUParticles2D.emitting = true
	var tween = create_tween()
	tween.tween_property($Path2D/PathFollow2D, "progress_ratio", 1, 1)
	tween.tween_interval(.02)
	#then the second smoke then tweens towards the player at the specific lerp speed
	#based off of the choice the player made
	$Smoke2/CPUParticles2D.emitting = true
	tween.tween_property($Smoke2, "position", $Imeris.position, Dialogic.VAR.lerpSpeed)
	#wait until the tween is done and then turn off everything and run the qte
	await get_tree().create_timer(1.5).timeout
	$Path2D/PathFollow2D/Smoke/CPUParticles2D.emitting = false
	#this will be changed to his smoke instead
	timerCheck = true
	defenseCheck = true    	
	
	

	
#the defense qte the player must do in order to not get hit
func DefenseQTE():
	#$EnemyQTE.visible = true
	#chooses a random arrow
	$LinSmoke.visible = true
	$LinAttackAnimationPlayer.play("chargeUp")
	$EnemyQTE.text = newRandomLetter
	#finds the node based off the name newRandomLetter
	#finds that arrow in the hirearchy and shows it
	tempArrow = find_child(newRandomLetter)
	tempArrow.visible = true
	#starts the timer
	if timerCheck == true:
		$EnemyQTE/EnemyTimer.start()
		timerCheck = false
	#if they press the button before the timer runs out
	if (Input.is_action_pressed(newRandomLetter+"Action")):
		#stop everything
		$EnemyQTE/EnemyTimer.stop()
		enemyTurnCheck = false
		defenseCheck = false
		#tell the player that linneaus missed but we no longer use that
		#instead the arrow just blinks
		$EnemyQTE.text = "MISS"
		$AnimationPlayer.play("DownArrow")
		#wait a fucking second so the animation can play
		#maybe try finished animation?
		await get_tree().create_timer(1).timeout
		#turn everything off
		$EnemyQTE.visible = false
		tempArrow.visible = false
		$Node2D.visible = true
		$LinSmoke.visible = false
		$Smoke2/CPUParticles2D.emitting = false
		$Smoke2.position = smokePosition
		#and start the next dalogue round
		var dialog = Dialogic.start(bossName + "Round" + (str(Dialogic.VAR.currentRound)))
		dialog.process_mode= Node.PROCESS_MODE_ALWAYS
		Dialogic.process_mode = Node.PROCESS_MODE_ALWAYS
		$AudioStreamPlayer2D.process_mode = Node.PROCESS_MODE_ALWAYS

		
		
#if the player chooses to attack, it paused dialogic to run their turn
func AttackSignal(argument: String):
	if argument == "AttackChoice":
		Dialogic.paused = true
		if (Dialogic.Text.is_textbox_visible()):
			Dialogic.Text.hide_textbox()
		else:
			Dialogic.Text.show_textbox()
		$Node2D.visible = false
		$letterShower/TextureProgressBar.value = 0
		startMinigame = true

#this starts the enemy turn in dialogic
func EnemySignal(argument: String):
	if argument == "EnemyTurn":
		newRandomLetter = letterArray.pick_random()
		$Node2D.visible = false
		$letterShower/TextureProgressBar.value = 0
		enemyTurn()

	
# player attack turn
func PlayerAttack():
	#if they pass the attack qte
	if (testPass == true):
		#sets all of the enemy stuff to false
		$letterShower.visible = false
		#play enemy hurt animation
		$AnimationPlayer.play("EnemyHurt")
		#await $AnimationPlayer.animation_finished
		tempArrow.visible = false
		testPass = false
		upCheck = false
		
		#decreases the enemy's health by 1 though we may not need this since the battle is on rails
		enemy.health -= 1
		print("enemy health ", enemy.health)

		print(enemy.health)
		#turn star guy off
		$Imeris/PlayerAttack.visible = false
		#make it so when you attack again you can do it the first time
		firstCheck = true
		var tween = create_tween()
		tween.tween_property($Imeris, 'position:y',  tweenPosition, 0.5)
		#if enemy health is 0 they are dead but this doesnt make sense any more take it out

		if (enemy.health <= 0):
			$AnimationPlayer.play("EnemyDied")
			await $AnimationPlayer.animation_finished
			await get_tree().create_timer(.25).timeout
		else:
			Dialogic.VAR.attackFinished = true
			Dialogic.paused = false
			if (Dialogic.Text.is_textbox_visible()== false):
				Dialogic.Text.show_textbox()


# attack qte minigame
func doMinigame():
	var tween = create_tween()
	#so that nothing shows up when it is visible
	if (Input.is_action_just_pressed("w")):
		tweenPosition = $Imeris.position.y
		print (tweenPosition)
		tween.tween_property($Imeris, 'position:y',  $Enemy.position.y + 50, 0.5)
		await get_tree().create_timer(.5).timeout
		upCheck = true
	tempArrow = null
	inputCheck = true
	$letterShower.visible =  true
	if upCheck == true:
		while (inputCheck == true):
			$letterShower.visible = false
			#$letterShower.text = letterToPress
			tempArrow = find_child(letterToPress)
			#checks to see if this is the first turn, if so set the arrow visible and then turn the check to false
			if firstCheck == true:
				tempArrow.visible = true
				firstCheck = false
			StepThrough()

			break
	
	
#this is the function that shows a new arrow everytime one is pressed
func StepThrough():
	if (Input.is_action_just_pressed(letterToPress + "Action")):
		$letterShower.visible = false
		tempArrow.visible = false
		await get_tree().create_timer(.1).timeout
		$letterShower/Timer.start()
		var randomLetter = letterArray.pick_random()
		$letterShower.text = randomLetter
		tempArrow = find_child(randomLetter)
		letterToPress = randomLetter
		print(letterToPress)
		currentLetter += 1
		var tween = create_tween()
		tween.tween_property($letterShower/TextureProgressBar,"value", $letterShower/TextureProgressBar.value + 20, 0.5)
		#$letterShower.visible = true
		tempArrow.visible = true
		if ($letterShower/TextureProgressBar.value >= 100):
			testPass = true
			PlayerAttack()
			TurnReset()


#if you miss an attack arrow the player gets hurt and everything resets
func _on_timer_timeout() -> void:
	var tween = create_tween()
	tween.tween_property($Imeris, 'position:y',  tweenPosition, 0.5)
	inputCheck = false
	upCheck = false
	firstCheck = true
	TurnReset()
	Dialogic.VAR.linAttack = true
	$AnimationPlayer.play("PlayerHurt")
	playerHealth -= 1
	if playerHealth == 0:
		Dialogic.VAR.attackFinished = true
		Dialogic.paused = false
		Dialogic.Text.show_textbox()
		Dialogic.start("PlayerDeath")
	else:
		
		Dialogic.VAR.attackFinished = true
		Dialogic.paused = false
		Dialogic.Text.show_textbox()
		Dialogic.start("PLayerHurt")
	

#turn reset function that resets everything after a player attack
func TurnReset():
	startMinigame = false
	$EnemyQTE.visible = false
	$LinSmoke.visible = false
	$letterShower/TextureProgressBar.value = 0
	currentLetter = 0
	$letterShower/Timer.stop()
	$letterShower.text = "press w to move forward"
	$letterShower.visible = false
	tempArrow.visible = false


#if the player missed the defense qte
#smoke stops emitting and goes back to its original position
#the player gets hurt and everything resets
func _on_enemy_timer_timeout() -> void:
	defenseCheck = false
	$Smoke2/CPUParticles2D.emitting = false
	$Smoke2/CPUParticles2D.position = smokePosition
	$EnemyQTE/EnemyTimer.stop()
	$AnimationPlayer.play("PlayerHurt")
	tempArrow.visible = false
	await $AnimationPlayer.animation_finished
	playerHealth -= 1
	if playerHealth ==0:
		Dialogic.start("PlayerDeath")
	print("player health ", playerHealth)
	TurnReset()
	$Node2D.visible = true
	var dialog = Dialogic.start(bossName + "Round" + (str(Dialogic.VAR.currentRound)))
	dialog.process_mode= Node.PROCESS_MODE_ALWAYS
	Dialogic.process_mode = Node.PROCESS_MODE_ALWAYS



#enemy area
func _on_player_area_area_entered(area: Area2D) -> void:
	if area.name == "EnemyArea":
		defenseCheck = true
		print(area.name)
		
		

#area entered when Lin is headless 1
func _on_headless_area_area_entered(area: Area2D) -> void:
	if area.name == "PlayerArea":
		print("u are in the correct area")
		currentDialogue = "Boss1AreaSignal"
		var dialog = Dialogic.start(currentDialogue)
		dialog.process_mode= Node.PROCESS_MODE_ALWAYS
		Dialogic.process_mode = Node.PROCESS_MODE_ALWAYS
		$AudioStreamPlayer2D.process_mode = Node.PROCESS_MODE_ALWAYS
		$ChapelV2/HeadlessArea.visible = false
		#this deletes the area so the player doesnt accidently hit it again
		$ChapelV2/HeadlessArea.queue_free()

#area entered when Lin is headless 1
func _on_headless_area_2_area_entered(area: Area2D) -> void:
	if area.name == "PlayerArea":
		print("u are in the correct area... again")
		currentDialogue = "Boss1AreaSignal2"
		var dialog = Dialogic.start(currentDialogue)
		dialog.process_mode= Node.PROCESS_MODE_ALWAYS
		Dialogic.process_mode = Node.PROCESS_MODE_ALWAYS
		$AudioStreamPlayer2D.process_mode = Node.PROCESS_MODE_ALWAYS
		$ChapelV2/HeadlessArea2.visible = false
		$ChapelV2/HeadlessArea2.queue_free()

#this stops imeris movement
func _giveVelocityBack(argument):
	if argument == "velocity":
		$Imeris.canMove = false



#when the battle ends the player can move again
func endVelocity(argument):
	if argument == "endVelocity":
		print("the battle has ended")
		$Imeris.canMove = true
