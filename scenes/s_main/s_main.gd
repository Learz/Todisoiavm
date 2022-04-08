extends Spatial

#-----------------SCENE--SCRIPT------------------#
#    Close your game faster by clicking 'Esc'    #
#   Change mouse mode by clicking 'Shift + F1'   #
#------------------------------------------------#

export var fast_close := false
var mouse_mode: String = "CAPTURED"

##################################################

var generator_thread : Thread
var vm_tex_generator = preload("res://entities/Vending Machine/VendingMachineTextureGenerator.tscn")
var drink_tex_generator = preload("res://entities/Vending Machine/Drinks/DrinkTextureGenerator.tscn")

func _ready() -> void:
	SoundManager.play_bgm("Bobbin")
	if fast_close:
		print("** Fast Close enabled in the 's_main.gd' script **")
		print("** 'Esc' to close 'Shift + F1' to release mouse **")
	
	#TODO : Fix how slow this is at the start
	#Generate vending machines and drinks textures
	generator_thread = Thread.new()
	generator_thread.start(self, "_generate_textures")


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		if fast_close:
			Global.quit() # Quits the game
		else:
			if !$TitleScreen.visible:
				$TitleScreen.open_menu()
			else:
				$TitleScreen.close_menu()
#	if event.is_action_pressed("mouse_input") and fast_close:
#		match mouse_mode: # Switch statement in GDScript
#			"CAPTURED":
#				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
#				mouse_mode = "VISIBLE"
#			"VISIBLE":
#				Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
#				mouse_mode = "CAPTURED"
	if event.is_action_pressed("dev_action"):
		generator_thread.wait_to_finish()
		generator_thread.start(self, "_generate_textures")
				
func _physics_process(_delta):
	$HUD.visible = Global.display_HUD
	$FPS_Counter.visible = Global.display_FPS
	$HUD/ReticleUI.visible = Global.display_reticle

# Texture Generation
# Instances Generators and generate all the textures
func _generate_textures(_empty):
	randomize()
#	yield(get_tree(), "idle_frame")
	
	yield(get_tree(), "idle_frame")
	# Instance all generators
	Global.vending_machine_textures = []
	for _i in range(Global.nb_vending_machine_textures):
		$VM_Tex_Generators.add_child(vm_tex_generator.instance())
	Global.drink_textures = []
	for _i in range(Global.nb_drink_textures):
		$Drink_Tex_Generators.add_child(drink_tex_generator.instance())
	
	# Wait for the generators to display the procedural textures
	yield(get_tree(), "idle_frame")
	
	# Extract and save the generated textures to the global texture arrays
	# Finally, remove all generator instances as they will not be used anymore
	for generator in $VM_Tex_Generators.get_children():
		yield(get_tree(), "idle_frame")
		var texture = ImageTexture.new()
		texture.create_from_image(generator.get_texture().get_data())
		Global.vending_machine_textures.push_back(texture)
		generator.queue_free()
	
	for generator in $Drink_Tex_Generators.get_children():
		yield(get_tree(), "idle_frame")
		var texture = ImageTexture.new()
		texture.create_from_image(generator.get_texture().get_data())
		Global.drink_textures.push_back(texture)
		generator.queue_free()
	
	Global.textures_generated = true

func _exit_tree():
	generator_thread.wait_to_finish()
