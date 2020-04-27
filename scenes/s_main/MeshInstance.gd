extends MeshInstance


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



func _process(delta):
	var playerPos = get_node("../Player").translation
	look_at(Vector3(playerPos.x, translation.y ,playerPos.z), Vector3.UP)
