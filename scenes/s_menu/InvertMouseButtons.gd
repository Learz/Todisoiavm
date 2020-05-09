extends CheckButton


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pressed = Global.invert_mouse_buttons
	pass # Replace with function body.

func _toggled(button_pressed):
	var clickEvent = InputEventMouseButton.new()
	InputMap.action_erase_events("left_click")
	InputMap.action_erase_events("right_click")
	if button_pressed:
		Global.invert_mouse_buttons = false
		clickEvent.button_index = BUTTON_LEFT
		InputMap.action_add_event("left_click", clickEvent)
		clickEvent.button_index = BUTTON_RIGHT
		InputMap.action_add_event("right_click", clickEvent)
	else:
		Global.invert_mouse_buttons = true
		clickEvent.button_index = BUTTON_RIGHT
		InputMap.action_add_event("left_click", clickEvent)
		clickEvent.button_index = BUTTON_LEFT
		InputMap.action_add_event("right_click", clickEvent)
