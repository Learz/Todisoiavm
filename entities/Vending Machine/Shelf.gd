extends Spatial

export var drinkType = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	generate_cans()
	pass # Replace with function body.

func generate_cans():
	for i in range(6):
		var can_scn = load("res://entities/Vending Machine/Vending_Machine_Option.tscn")
		var can : Spatial = can_scn.instance()
		can.drinkType = drinkType
		can.translation = Vector3(-0.85+(0.3*i),0.3,0.04)
		add_child(can)
	pass
