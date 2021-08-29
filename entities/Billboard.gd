tool
extends Spatial
class_name Billboard

export var four_sided := false setget set_four_sided
export (Texture) var texture setget set_texture
export (Texture) var normalMap setget set_normal
export (float, 0, 360) var direction setget set_direction

func set_four_sided(set):
	if set:
		$SpriteQuad.get_surface_material(0).uv1_scale = Vector3(0.25,1,1)
	else:
		$SpriteQuad.get_surface_material(0).uv1_scale = Vector3(1,1,1)
	four_sided = set

func set_texture(tex):
	$SpriteQuad.get_surface_material(0).albedo_texture = tex
	texture = tex
	
func set_normal(tex):
	$SpriteQuad.get_surface_material(0).normal_texture = tex
	normalMap = tex
	
func set_direction(dir):
	$Direction.rotation_degrees = Vector3(-90,dir,0)
	direction = dir

func _ready():
	$SpriteQuad.set_surface_material(0, $SpriteQuad.get_surface_material(0).duplicate())

func _process(delta):
	if get_viewport().get_camera():
		var playerPos = get_viewport().get_camera().owner.translation
		$SpriteQuad.look_at(playerPos, Vector3.UP)
		$SpriteQuad.rotation = Vector3(0, $SpriteQuad.rotation.y, 0)
		
		if four_sided:
			var playerPosToSprite = (rotation.y - PI / 4) + Vector2(translation.x, translation.z).angle_to_point(Vector2(playerPos.x, playerPos.z))
			var currentOffset = floor(playerPosToSprite/(PI/2))/4
			$SpriteQuad.get_surface_material(0).uv1_offset = Vector3(currentOffset,0,0)
