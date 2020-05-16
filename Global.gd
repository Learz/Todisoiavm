extends Node

#Texture Generation
signal textures_generated
var textures_generated = false setget set_tex_gen
var nb_vending_machine_textures = 10
var vending_machine_textures = []
var nb_can_textures = 20
var can_textures = []

#Settings
var invert_mouse_buttons = false setget set_invert_mouse_buttons
var display_FPS = false
var setting_reticle = false setget set_setting_reticle
enum WINDOW_MODE {WINDOWED, FULLSCREEN, BORDERLESS}
var window_mode = 0 setget set_window_mode
var config_path = "res://Config.cfg"

#Global states
var paused = true
var display_HUD = false
var display_reticle = false setget set_reticle

func set_invert_mouse_buttons(s):
	invert_mouse_buttons = s
	var clickEvent = InputEventMouseButton.new()
	InputMap.action_erase_events("left_click")
	InputMap.action_erase_events("right_click")
	if s:
		clickEvent.button_index = BUTTON_LEFT
		InputMap.action_add_event("left_click", clickEvent)
		clickEvent.button_index = BUTTON_RIGHT
		InputMap.action_add_event("right_click", clickEvent)
	else:
		clickEvent.button_index = BUTTON_RIGHT
		InputMap.action_add_event("left_click", clickEvent)
		clickEvent.button_index = BUTTON_LEFT
		InputMap.action_add_event("right_click", clickEvent)

func set_setting_reticle(s):
	display_reticle = s
	setting_reticle = s

func set_reticle(s):
	if setting_reticle:
		display_reticle = s

func set_window_mode(s):
	window_mode = s
	match window_mode:
		WINDOW_MODE.WINDOWED:
			OS.window_fullscreen = false
			OS.window_borderless = false
			OS.window_maximized = false
		WINDOW_MODE.FULLSCREEN:
			OS.window_maximized = false
			OS.window_borderless = false
			OS.window_fullscreen = true
		WINDOW_MODE.BORDERLESS:
			OS.window_borderless = true
			OS.window_maximized = true

func set_tex_gen(v):
	textures_generated = v
	emit_signal("textures_generated")

# Called when the node enters the scene tree for the first time.
func _ready():
	load_config()
	pass
	
func quit():
	save_config()
	get_tree().quit()

func _notification(what):
	if (what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST):
		quit()
		
#func generate_textures():
#	randomize()
#	vending_machine_textures = []
#	for i in range(Global.nb_vending_machine_textures):
#		$VM_Tex_Generator/Dynamic_Texture.generate_brand()
#		yield(get_tree(), "idle_frame")
#		yield(get_tree(), "idle_frame")
#		var texture = ImageTexture.new()
#		texture.create_from_image($VM_Tex_Generator.get_texture().get_data())
#		vending_machine_textures.push_back(texture)
#
#	can_textures = []
#	for i in range(Global.nb_can_textures):
#		$Drink_Tex_Generator/Dynamic_Texture.generate_brand()
#		yield(get_tree(), "idle_frame")
#		yield(get_tree(), "idle_frame")
#		var texture = ImageTexture.new()
#		texture.create_from_image($Drink_Tex_Generator.get_texture().get_data())
#		can_textures.push_back(texture)
#	textures_generated = true

func save_config():
	# Initiate ConfigFile 
	var configFile = ConfigFile.new()  
	
	# Custom settings 
	configFile.set_value("Display","fps", display_FPS) 
	configFile.set_value("Display","reticle", setting_reticle)
	configFile.set_value("Display","window_mode", window_mode)
	configFile.set_value("Display","resolution", OS.window_size)
	
	configFile.set_value("Input","invert_mouse_buttons", invert_mouse_buttons)
	# Actions
	for a in InputMap.get_actions():
		configFile.set_value("Input", a, InputMap.get_action_list(a))
	
	# Save file 
	configFile.save(config_path)
	
func load_config():
	# Initiate ConfigFile  
	var configFile= ConfigFile.new() 
	
	# Load file 
	assert(configFile.load(config_path) != null)
	
	var config
	
	config = configFile.get_value("Display", "fps")
	if config : display_FPS = config
	
	config = configFile.get_value("Display", "reticle")
	if config : setting_reticle = config
	
	config = configFile.get_value("Display", "resolution")
	if config : OS.window_size = config
	
	config = configFile.get_value("Display", "window_mode")
	if config : set_window_mode(config)
	
	config = configFile.get_value("Input", "invert_mouse_buttons")
	if config : invert_mouse_buttons = config
	
	for a in InputMap.get_actions():
		config = configFile.get_value("Input", a)
		if config:
			InputMap.action_erase_events(a)
			for c in config: 
				InputMap.action_add_event(a, c)


#func _on_VM_Tex_Generator_ready():
#	generate_textures()
