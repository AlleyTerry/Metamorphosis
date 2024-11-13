extends Node2D

var pointArray = []
@export var marker: Node2D
var arraymarker: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#add markers to array
	pointArray.append($Marker2D)
	pointArray.append($Marker2D2)
	pointArray.append($Marker2D3)
	#set the initial position
	marker.position = pointArray[2].position
	arraymarker = 1


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	snapMovement()
	


func snapMovement():
	if Input.is_action_just_pressed("LeftAction"):
		#the marker will jump to the position to its left
		if arraymarker <= 0:
			arraymarker = 0
		else:
			marker.position = pointArray[arraymarker - 1].position
			arraymarker = arraymarker -1
	
	if Input.is_action_just_pressed("RightAction"):
		#the marker will jump to the right if the marker is all the way to the right
		#make it go nowhere
		if arraymarker >=2:
			arraymarker = 2
		else:
			marker.position = pointArray[arraymarker + 1].position
			arraymarker = arraymarker +1
		
		
