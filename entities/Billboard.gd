tool
extends MeshInstance


export var four_sided := false setget set_four_sided
export (Texture) var texture setget set_texture
export (Texture) var normalMap setget set_normal

func set_four_sided(set):
	if set:
		get_surface_material(0).uv1_scale = Vector3(0.25,1,1)
	else:
		get_surface_material(0).uv1_scale = Vector3(1,1,1)
	four_sided = set

func set_texture(tex):
	get_surface_material(0).albedo_texture = tex
	texture = tex
	
func set_normal(tex):
	get_surface_material(0).normal_texture = tex
	normalMap = tex

func _ready():
	set_surface_material(0, get_surface_material(0).duplicate())
	pass

func _process(delta):
	if get_viewport().get_camera():
		var playerPos = get_viewport().get_camera().owner.translation
		look_at(Vector3(playerPos.x, translation.y ,playerPos.z), Vector3.UP)
	
		if four_sided:
			var playerPosToSprite = Vector2(translation.x, translation.z).angle_to_point(Vector2(playerPos.x, playerPos.z))-PI/4
			var currentOffset = floor(playerPosToSprite/(PI/2))/4
			get_surface_material(0).uv1_offset = Vector3(currentOffset,0,0)
