tool
extends Button


# Declare member variables here. Examples:
export (StreamTexture) var iconTex setget set_icon_tex
export (String) var title setget set_title
 
onready var tween : Tween = owner.get_node("Tween")

func set_icon_tex(tex):
	if $VBoxContainer/TextureRect:
		iconTex = tex
		$VBoxContainer/TextureRect.texture = iconTex
	
func set_title(txt):
	if $VBoxContainer/Label:
		title = txt
		$VBoxContainer/Label.text = title

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("mouse_entered", self, "_on_mouse_over")
	connect("mouse_exited", self, "_reset_size")
	connect("focus_entered", self, "_on_mouse_over")
	connect("focus_exited", self, "_reset_size")
	connect("button_down", self, "_on_button_down")
	connect("button_up", self, "_reset_size")

func _on_mouse_over():
	tween.interpolate_property(self, "rect_scale", rect_scale, Vector2(1.2,1.2), 0.1)
	tween.start()
	
func _reset_size():
	tween.interpolate_property(self, "rect_scale", rect_scale, Vector2(1,1), 0.1)
	tween.start()
	
func _on_button_down():
	tween.interpolate_property(self, "rect_scale", rect_scale, Vector2(0.9,0.9), 0.1, Tween.TRANS_BACK, Tween.EASE_OUT)
	tween.start()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
