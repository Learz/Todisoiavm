extends Control

var brands := ["Markis", "Mark Coffee", "Mork", "Marksi", "Markahi"]

# Called when the node enters the scene tree for the first time.
func _ready():
	generate_brand()
	pass # Replace with function body.
	
func generate_brand():
	get_viewport().render_target_update_mode = Viewport.UPDATE_ONCE
	var rnd = randf()
	
	#var ticks = OS.get_ticks_msec()
	var hue = rnd
	var vmCol = Color.from_hsv(hue,0.7,1,1)
	$VMC1.color = vmCol
	$VMC2.color = vmCol
	$VMC3.color = vmCol
	$SidePanelText.text = brands[randi() % brands.size()]
	
#	$SidePanelText.text = str(rnd)
