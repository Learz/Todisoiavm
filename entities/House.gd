tool
extends Spatial

export (Array, Color) var colors
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$House/Cut.visible = randi() & 1
	$House/RoofInvert.visible = randi() & 1
	#$House/Cut.translation(Vector3(rand_range(-2,1),0,rand_range(-2,1)))
	var roofAngle = rand_range(-15,0)
	$House/Roof.rotation_degrees = Vector3(roofAngle,0,0)
	$House/RoofInvert.rotation_degrees = Vector3(roofAngle,0,0)
	#$House/Roof.translation = Vector3(0,rand_range(-1,0),0)
	#$House/RoofInvert.translation = Vector3(0,rand_range(-2,0),0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
