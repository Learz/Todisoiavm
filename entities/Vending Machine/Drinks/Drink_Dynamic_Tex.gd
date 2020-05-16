extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	pass
	
func generate_brand():
	get_viewport().render_target_update_mode = Viewport.UPDATE_ONCE
	var rnd = randf()
	var hot = randi() & 1
	var price = rand_range(8,15)
	
	var hue = rnd
	var botCol = Color.from_hsv(hue,1,1,1)
	$Brand.color = botCol
	$Price/VBoxContainer/Label.text = "%d0" % price
	$Price/VBoxContainer/HotLabel.visible = hot
	$Price/VBoxContainer/ColdLabel.visible = !hot
