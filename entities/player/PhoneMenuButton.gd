tool
extends Button


# Declare member variables here. Examples:
export (StreamTexture) var iconTex setget set_icon_tex
export (String) var title setget set_title
export (NodePath) var app
 
onready var tween : Tween = owner.get_node("Tween")

var is_ready = false

func set_icon_tex(tex):
	iconTex = tex
	$VBoxContainer/TextureRect.texture = iconTex
	
func set_title(txt):
	title = txt
	$VBoxContainer/Label.text = title

# Called when the node enters the scene tree for the first time.
func _ready():
	is_ready = true
#	connect("mouse_entered", self, "_on_mouse_over")
#	connect("mouse_exited", self, "_on_mouse_exit")
#	connect("focus_entered", self, "_on_focus_entered")
#	connect("focus_exited", self, "_reset_size")
	connect("button_down", self, "_on_button_down")
	connect("button_up", self, "_reset_size")
#
#func _on_mouse_over():
#	_on_focus_entered()
#
#func _on_focus_entered():
#	tween.interpolate_property(self, "rect_scale", rect_scale, Vector2(1.2,1.2), 0.1)
#	tween.start()
#
#func _on_mouse_exit():
#	_reset_size()
#
func _reset_size():
	tween.interpolate_property(self, "rect_scale", rect_scale, Vector2(1,1), 0.1)
	tween.start()
#
func _on_button_down():
	tween.interpolate_property(self, "rect_scale", rect_scale, Vector2(0.9,0.9), 0.1, Tween.TRANS_BACK, Tween.EASE_OUT)
	tween.start()

func _pressed():
	if app:
		owner.get_node("Tween").interpolate_property(get_node(app), "rect_position", null, Vector2(0,0), 0.5, Tween.TRANS_QUART)
		owner.get_node("Tween").interpolate_property(get_node(app), "rect_scale", null, Vector2(1,1), 0.8, Tween.TRANS_CIRC)
		owner.get_node("Tween").start()
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
