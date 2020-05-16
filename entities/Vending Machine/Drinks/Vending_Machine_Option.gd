extends Spatial

export (Array, Mesh) var drinkTypes
export (int, 0, 2) var drinkType = 0 setget set_drink_type

onready var tween : Tween = get_node("Tween")
var buttonPos

func set_drink_type(dt):
	drinkType = dt
	$Drink.mesh = drinkTypes[dt]

# Called when the node enters the scene tree for the first time.
func _ready():
	buttonPos = $Button.translation
	
	yield(Global, "textures_generated")
	$Drink.set_surface_material(0, load("res://resources/models/Vending Machine/Drink_Mat.tres").duplicate())
	$PriceTag.set_surface_material(0, $Drink.get_surface_material(0))
	set_texture()

func set_texture():
	var tex_id = randi()%Global.nb_can_textures
	#TO FIX : Crashes when generated too fast
	$Drink.get_surface_material(0).albedo_texture = Global.can_textures[tex_id]

func _on_ButtonBody_input_event(camera, event, click_position, click_normal, shape_idx):
	if event.is_action_pressed("left_click"):
		SoundManager.play_se("Blip_Select", true, false)
		tween.interpolate_property($Button, "translation", null, buttonPos + Vector3(0,0,-0.05), 0.1)
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
