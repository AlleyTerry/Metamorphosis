extends Node2D

@export var enemy: Resource = null
@export var playerHealth = 35

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	enemy.health = 55
	print (enemy.health)
	$Enemy/CollisionShape2D/Sprite2D.texture = enemy.texture

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func enemyTurn():
	playerHealth -= 10
	$AnimationPlayer.play("enemy_attack")
	await $AnimationPlayer.animation_finished
	$AnimationPlayer.play("PlayerHurt")
	await $AnimationPlayer.animation_finished

func _on_attack_button_pressed() -> void:
	enemy.health -= 10
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
		enemyTurn()


func _on_talk_button_pressed() -> void:
	pass
	
