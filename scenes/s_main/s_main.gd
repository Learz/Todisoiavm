extends Spatial

#-----------------SCENE--SCRIPT------------------#
#    Close your game faster by clicking 'Esc'    #
#   Change mouse mode by clicking 'Shift + F1'   #
#------------------------------------------------#

export var fast_close := true
var mouse_mode: String = "CAPTURED"

##################################################

func _ready() -> void:
	if fast_close:
		print("** Fast Close enabled in the 's_main.gd' script **")
		print("** 'Esc' to close 'Shift + F1' to release mouse **")


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel") and fast_close:
		get_tree().quit() # Quits the game
	
	if event.is_action_pressed("mouse_input") and fast_close:
		match mouse_mode: # Switch statement in GDScript
			"CAPTURED":
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
				mouse_mode = "VISIBLE"
			"VISIBLE":
				Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
				mouse_mode = "CAPTURED"
	if event.is_action_pressed("dev_action"):
		generate_textures()
				
func generate_textures():
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
