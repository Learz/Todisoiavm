extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func grab_focus():
	$HBoxContainer/TextureRect/VBoxContainer/Content/Home/GridContainer/MusicIcon.grab_focus()
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_HomeButton_pressed():
	for app in $HBoxContainer/TextureRect/VBoxContainer/Content.get_children():
		if app.name != "Home":
			$Tween.interpolate_property(app, "rect_position", null, Vector2(0,600), 0.5, Tween.TRANS_QUART)
			$Tween.interpolate_property(app, "rect_scale", null, Vector2(0.2,0.2), 0.8, Tween.TRANS_CIRC)
			$Tween.start()
	pass # Replace with function body.

