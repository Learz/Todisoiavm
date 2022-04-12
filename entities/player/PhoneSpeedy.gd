extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_Speed_pressed():
	if Global.debug_speed_multiplier != 1:
		$VBoxContainer/TitleSpeedy.text = "Not speedy"
		Global.debug_speed_multiplier = 1
	else:
		$VBoxContainer/TitleSpeedy.text = "!!Speedy!!"
		Global.debug_speed_multiplier = 5


func _on_Noclip_pressed():
	Global.debug_noclip = !Global.debug_noclip
	if Global.debug_noclip:
		$VBoxContainer/TitleNoclip.text =  "Not colliding"
	else:
		$VBoxContainer/TitleNoclip.text = "Colliding"
