extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	pass
	
func generate_brand(rndSeed):
	get_viewport().render_target_update_mode = Viewport.UPDATE_ONCE
	
	#var ticks = OS.get_ticks_msec()
	var hue = rndSeed
	var vmCol = Color.from_hsv(hue,1,1,1)
	$VMC1.color = vmCol
	$VMC2.color = vmCol
	$VMC3.color = vmCol
	
	$SidePanelText.text = str(rndSeed)
