tool
extends Spatial

export (Array, Color) var colors
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$CSGCombiner/Cut.visible = randi() & 1
	$CSGCombiner/RoofInvert.visible = randi() & 1
	$CSGCombiner/Cut.translate(Vector3(rand_range(-0.5,0.2),0,rand_range(-0.5,0.2)))
	var roofAngle = rand_range(-0.1,0)
	$CSGCombiner/Roof.rotate(Vector3(1,0,0), roofAngle)
	$CSGCombiner/RoofInvert.rotate(Vector3(1,0,0), -roofAngle)
	$CSGCombiner/Roof.translate(Vector3(0,rand_range(-0.5,0),0))
	$CSGCombiner/RoofInvert.translate(Vector3(0,rand_range(-0.5,0),0))


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
