extends Control

const startLabelChange = "Continue Wandering"
var current_node

func _ready():
	current_node = $MainMenu
	get_tree().get_root().connect("size_changed", self, "_on_resize")
	$MainMenu/Menu/CenterRow/Buttons/StartBtn.grab_focus()
	for button in $MainMenu/Menu/CenterRow/Buttons.get_children():
		button.connect("pressed", self, "_on_Button_Pressed", [button.link, button.type])
	$MainMenu/Menu/CenterRow/CompanyBtn.connect("pressed", self, "_on_Button_Pressed", [$MainMenu/Menu/CenterRow/CompanyBtn.link, $MainMenu/Menu/CenterRow/CompanyBtn.type])
	$Options/Menu/BackBtn.connect("pressed", self, "_on_Button_Pressed", [$Options/Menu/BackBtn.link, $Options/Menu/BackBtn.type])

func _on_resize():
	jump_to_node(current_node)

func _on_Button_Pressed(link, type):
	match type:
		0:
			#get_tree().change_scene(link)
			scene_manager.change_scene_to(link, true)
		1:
			OS.shell_open(link)
		2:
			Global.quit()
		3:
			jump_to_node(get_node(link))
		4:
			close_menu()

func jump_to_node(n : Node):
	current_node = n
	var focusNode = get_first_button(n)
	if focusNode:
		focusNode.grab_focus()
	$Tween.interpolate_property(self, "rect_position", null, -n.rect_position, 1, Tween.TRANS_QUINT, Tween.EASE_OUT)
	$Tween.start()

func close_menu():
	Global.display_HUD = true
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	Global.paused = false
	var tweenSpeed = 0.5
	if $MainMenu/Menu/CenterRow/Buttons/StartBtn.title != startLabelChange:
		tweenSpeed = 1
	$Tween.interpolate_property(self, "modulate", null, Color(1,1,1,0), tweenSpeed)
	$Tween.start()
	yield($Tween, "tween_all_completed")
	$MainMenu/Menu/CenterRow/Buttons/StartBtn.title = startLabelChange
	visible = false
	
func open_menu():
	Global.display_HUD = false
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	Global.paused = true
	visible = true
	$Tween.interpolate_property(self, "modulate", null, Color(1,1,1,1), 0.5)
	$Tween.start()

func get_first_button(node):
	var rN = null
	for N in node.get_children() :
		if N.get_class() == "Button":
			return N
		if N.get_child_count() > 0:
			rN = get_first_button(N)
			if rN:
				return rN
