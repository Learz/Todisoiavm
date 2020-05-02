tool
extends Button


# Declare member variables here. Examples:
export (StreamTexture) var iconTex setget set_icon_tex
export (String) var title setget set_title
 
onready var tween : Tween = owner.get_node("Tween")

var is_ready = false

func set_icon_tex(tex):
	if not is_ready:
		return
	iconTex = tex
	$VBoxContainer/TextureRect.texture = iconTex
	
func set_title(txt):
	if not is_ready:
		return
	title = txt
	$VBoxContainer/Label.text = title

# Called when the node enters the scene tree for the first time.
func _ready():
	is_ready = true
	connect("mouse_entered", self, "_on_mouse_over")
	connect("mouse_exited", self, "_on_mouse_exit")
	connect("focus_entered", self, "_on_focus_entered")
	connect("focus_exited", self, "_reset_size")
	connect("button_down", self, "_on_button_down")
	connect("button_up", self, "_reset_size")

func _on_mouse_over():
	#Input.set_default_cursor_shape(Control.CURSOR_POINTING_HAND)
	_on_focus_entered()

func _on_focus_entered():
	tween.interpolate_property(self, "rect_scale", rect_scale, Vector2(1.2,1.2), 0.1)
	tween.start()

func _on_mouse_exit():
	#Input.set_default_cursor_shape(Control.CURSOR_ARROW)
	_reset_size()

func _reset_size():
	tween.interpolate_property(self, "rect_scale", rect_scale, Vector2(1,1), 0.1)
	tween.start()
	
func _on_button_down():
	tween.interpolate_property(self, "rect_scale", rect_scale, Vector2(0.9,0.9), 0.1, Tween.TRANS_BACK, Tween.EASE_OUT)
	tween.start()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
