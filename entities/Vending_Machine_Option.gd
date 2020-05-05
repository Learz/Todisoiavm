extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var tween : Tween = get_node("Tween")
var buttonPos

# Called when the node enters the scene tree for the first time.
func _ready():
	buttonPos = $Button.translation
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_ButtonBody_input_event(camera, event, click_position, click_normal, shape_idx):
	if event.is_action_pressed("left_click"):
		tween.interpolate_property($Button, "translation", null, buttonPos + Vector3(0,0,-0.08), 0.1)
		tween.start()
		yield(tween, "tween_completed")
		tween.interpolate_property($Button, "translation", null, buttonPos, 0.2)
		tween.start()
		#$Button.translate(Vector3(0,0,-0.01))


func _on_ButtonBody_mouse_entered():
	Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)
	pass


func _on_ButtonBody_mouse_exited():
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)
	pass
