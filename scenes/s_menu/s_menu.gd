extends Control

func _ready():
	$Menu/CenterRow/Buttons/StartBtn.grab_focus()
	for button in $Menu/CenterRow/Buttons.get_children():
		button.connect("pressed", self, "_on_Button_Pressed", [button.link, button.type])
	$Menu/CenterRow/CompanyBtn.connect("pressed", self, "_on_Button_Pressed", [$Menu/CenterRow/CompanyBtn.link, $Menu/CenterRow/CompanyBtn.type])
		
func _on_Button_Pressed(link, type):
	match type:
		0:
			scene_manager.change_scene_to(link)
		1:
			OS.shell_open(link)
		2:
			get_tree().quit()
	
func _on_Fade_in_animation_finished():
	pass
