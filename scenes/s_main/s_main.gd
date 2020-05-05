extends Spatial

#-----------------SCENE--SCRIPT------------------#
#    Close your game faster by clicking 'Esc'    #
#   Change mouse mode by clicking 'Shift + F1'   #
#------------------------------------------------#

export var fast_close := false


var mouse_mode: String = "CAPTURED"

##################################################

func _ready() -> void:
	if fast_close:
		print("** Fast Close enabled in the 's_main.gd' script **")
		print("** 'Esc' to close 'Shift + F1' to release mouse **")


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		if fast_close:
			get_tree().quit() # Quits the game
		else:
			if !$TitleScreen.visible:
				Global.display_HUD = false
				$TitleScreen.open_menu()
			else:
				Global.display_HUD = true
				$TitleScreen.close_menu()
#	if event.is_action_pressed("mouse_input") and fast_close:
#		match mouse_mode: # Switch statement in GDScript
#			"CAPTURED":
#				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
#				mouse_mode = "VISIBLE"
#			"VISIBLE":
#				Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
#				mouse_mode = "CAPTURED"
#	if event.is_action_pressed("dev_action"):
#		generate_textures()
				
func _process(delta):
	$HUD.visible = Global.display_HUD
	$FPS_Counter.visible = Global.display_FPS
	$HUD/Reticle.visible = Global.display_reticle
	

func generate_textures():
	randomize()
	Global.vending_machine_textures = []
	for i in range(Global.nb_vending_machine_textures):
		$Viewport/Dynamic_Texture.generate_brand(randf())
		yield(get_tree(), "idle_frame")
		yield(get_tree(), "idle_frame")
		var texture = ImageTexture.new()
		texture.create_from_image($Viewport.get_texture().get_data())
		Global.vending_machine_textures.push_back(texture)
	Global.textures_generated = true


func _on_Viewport_ready():
	generate_textures()
