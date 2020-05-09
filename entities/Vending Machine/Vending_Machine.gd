extends Spatial

export (int) var texture_id = 0

var is_ready = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$Machine.set_surface_material(0, $Machine.get_surface_material(0).duplicate())
	$Door.set_surface_material(0, $Machine.get_surface_material(0))
	
	yield(Global, "textures_generated")
	set_texture()
	
	#generate_cans()
	is_ready = true

#func _input(event):
#	if event.is_action_pressed("dev_action"):
#		set_texture()

func _process(delta):
	#$Change_Lever.rotate(Vector3(0,0,1), 0.2)
	pass

func set_texture():
	var tex_id = randi()%Global.nb_vending_machine_textures
	#TO FIX : Crashes when generated too fast
	$Machine.get_surface_material(0).albedo_texture = Global.vending_machine_textures[texture_id]
	$Door.get_surface_material(0).albedo_texture = Global.vending_machine_textures[texture_id]

func _on_StaticBody_input_event(camera, event: InputEvent, click_position, click_normal, shape_idx):
	if event.is_action_pressed("left_click"):
		$Change_Lever.rotate(Vector3(0,0,1),5)
