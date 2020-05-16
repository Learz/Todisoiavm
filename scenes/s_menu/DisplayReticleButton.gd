extends CheckButton

func _ready():
	pressed = Global.setting_reticle

func _toggled(button_pressed):
	Global.setting_reticle = button_pressed
