extends Label


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _process(_delta):
	var timeDict = OS.get_time();
	var hour = timeDict.hour;
	var minute = timeDict.minute;
	
	text = ("%02d:%02d" % [hour, minute])
