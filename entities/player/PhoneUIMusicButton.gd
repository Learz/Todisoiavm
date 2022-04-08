extends TextureButton

onready var tween : Tween = owner.get_node("Tween")

# Called when the node enters the scene tree for the first time.
func _ready():
#	connect("mouse_entered", self, "_on_mouse_over")
#	connect("mouse_exited", self, "_on_mouse_exit")
#	connect("focus_entered", self, "_on_focus_entered")
#	connect("focus_exited", self, "_reset_size")
	connect("button_down", self, "_on_button_down")
	connect("button_up", self, "_reset_size")

#func _on_mouse_over():
#	_on_focus_entered()
#
#func _on_focus_entered():
#	tween.interpolate_property(self, "rect_scale", rect_scale, Vector2(1.2,1.2), 0.1)
#	tween.start()
#
#func _on_mouse_exit():
#	_reset_size()

func _reset_size():
	tween.interpolate_property(self, "rect_scale", rect_scale, Vector2(1,1), 0.1)
	tween.start()
	
func _on_button_down():
	tween.interpolate_property(self, "rect_scale", rect_scale, Vector2(0.9,0.9), 0.1, Tween.TRANS_BACK, Tween.EASE_OUT)
	tween.start()
