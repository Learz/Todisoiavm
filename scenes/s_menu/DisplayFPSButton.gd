extends CheckButton

func _ready():
	pressed = Global.display_FPS

func _toggled(button_pressed):
	Global.display_FPS = button_pressed
