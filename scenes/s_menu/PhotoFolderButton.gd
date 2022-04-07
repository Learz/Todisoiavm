extends Button


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _pressed():
	#FIX : Dir creation not working on build??
	var dir = Directory.new()
	dir.open("res://")
	if not dir.dir_exists("TODISOIAVM Photos"): 
		dir.make_dir("TODISOIAVM Photos")
	dir.open("TODISOIAVM Photos")
	OS.shell_open(str("file://", dir.get_current_dir()))
