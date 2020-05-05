extends CheckButton


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pressed = Global.setting_reticle
	pass # Replace with function body.

func _toggled(button_pressed):
	Global.setting_reticle = button_pressed
