extends Button

export(String) var link
export(int, "Scene", "Url", "Quit") var type := 2

func _on_MenuButton_focus_entered():
	$Label.add_color_override("font_color", Color(0.8,0.8,0.8))

func _on_MenuButton_focus_exited():
	$Label.set("custom_colors/font_color", null)

func _on_MenuButton_mouse_entered():
	$Label.add_color_override("font_color", Color(0.8,0.8,0.8))

func _on_MenuButton_mouse_exited():
	$Label.set("custom_colors/font_color", null)

func _on_MenuButton_button_down():
	$Label.add_color_override("font_color", Color(0.5,0.5,0.5))

func _on_MenuButton_button_up():
	$Label.set("custom_colors/font_color", null)
