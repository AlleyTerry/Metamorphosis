extends CharacterBody2D


func _ready():
	$MoveTimer.start()
	
func _physics_process(delta: float) -> void:
	pass

func ChoosePosition():
	var tween = create_tween()
	tween.tween_property(self, 'position:y', randi_range(0,500), 0.5)
	$MoveTimer.start()

func newTime():
	$MoveTimer.wait_time /= 2
	print($MoveTimer.wait_time)
	

func destroy():
	get_parent().remove_child(self)
	queue_free()


func _on_move_timer_timeout() -> void:
	ChoosePosition()
	
