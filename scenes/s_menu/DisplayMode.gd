extends MenuButton

# Called when the node enters the scene tree for the first time.
func _ready():
	if OS.window_fullscreen:
		text = "Fullscreen"
	elif OS.window_borderless:
		text = "Borderless Window"
	else:
		text = "Windowed"
	get_popup().connect("id_pressed", self, "_on_item_pressed")
	pass # Replace with function body.

func _on_item_pressed(id):
	match id:
		0:
			Global.window_mode = Global.WINDOW_MODE.WINDOWED
			text = "Windowed"
			OS.window_fullscreen = false
			OS.window_borderless = false
			OS.window_maximized = false
			OS.window_size = Vector2(1280,720)
		1:
			Global.window_mode = Global.WINDOW_MODE.FULLSCREEN
			text = "Fullscreen"
			OS.window_borderless = false
			OS.window_fullscreen = true
		2:
			Global.window_mode = Global.WINDOW_MODE.BORDERLESS
			text = "Borderless Window"
			OS.window_borderless = true
			OS.window_maximized = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
