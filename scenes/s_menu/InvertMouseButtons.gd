extends CheckButton


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pressed = Global.invert_mouse_buttons
	pass # Replace with function body.

func _toggled(button_pressed):
	Global.invert_mouse_buttons = button_pressed
