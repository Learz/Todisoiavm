extends Spatial

export (Array) var drinkTypes : Array
export (int, 0, 2) var drinkType := 0 setget set_drink_type

onready var tween : Tween = get_node("Tween")
var buttonPos

var drink
var model_options = {
	0 : [1,3,4,12], 
	1 : [0,2,11], 
	2 : [5,6,7,8,9,10]
	}

func set_drink_type(dt):
	drinkType = dt % drinkTypes.size()
	drink = drinkTypes[model_options[dt][randi()%model_options[dt].size()]].instance()
	$DrinkAnchor.add_child(drink)
#	$Drink.mesh = drinkTypes[dt]

# Called when the node enters the scene tree for the first time.
func _ready():
	buttonPos = $Button.translation
	
	#TODO : Change new bottles textures
#	$Drink.set_surface_material(0, load("res://resources/models/Vending Machine/Drink_Mat.tres").duplicate())
#	$PriceTag.set_surface_material(0, $Drink.get_surface_material(0))
#	set_texture()

func set_texture():
	var tex_id = randi()%Global.nb_drink_textures
	#TO FIX : Crashes when generated too fast
	$Drink.get_surface_material(0).albedo_texture = Global.drink_textures[tex_id]

func _on_ButtonBody_input_event(camera, event, click_position, click_normal, shape_idx):
	if event.is_action_pressed("left_click"):
		#TODO : Spawn the drink, give script to drink
		#TODO : Change the sound to a more accurate vending button
		SoundManager.play_se("Blip_Select", true, false)
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
