tool
extends Spatial

export(Array, Texture) var plant_textures

const BILLBOARD = preload("res://entities/Billboard.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(14):
		if randi() % 2 == 1:
			var plant = BILLBOARD.instance()
			plant.texture = plant_textures[randi() % plant_textures.size()]
			get_node("PlantSocket" + str(i+1)).add_child(plant)
			plant.global_transform = get_node("PlantSocket" + str(i+1)).global_transform
			# TODO : Fix the billboards skewing when getting close


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
