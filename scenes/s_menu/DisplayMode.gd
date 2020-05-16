extends MenuButton

func _ready():
	set_current_mode_text()
	get_popup().connect("id_pressed", self, "_on_item_pressed")

func _on_item_pressed(id):
	match id:
		0:
			Global.window_mode = Global.WINDOW_MODE.WINDOWED
			OS.window_size = Vector2(1280,720)
		1:
			Global.window_mode = Global.WINDOW_MODE.FULLSCREEN
		2:
			Global.window_mode = Global.WINDOW_MODE.BORDERLESS
	set_current_mode_text()

func set_current_mode_text():
	match Global.window_mode:
		Global.WINDOW_MODE.WINDOWED:
			text = "Windowed"
		Global.WINDOW_MODE.BORDERLESS:
			text = "Borderless Window"
		Global.WINDOW_MODE.FULLSCREEN:
			text = "Fullscreen"
