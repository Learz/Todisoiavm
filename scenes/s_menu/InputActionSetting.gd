tool
extends HBoxContainer

export (String) var actionName setget setActionName
export (String) var realActionName

var events
var wait_for_input

func setActionName(n):
	actionName = n
	yield(self, "ready")
	$Name.text = actionName

# Called when the node enters the scene tree for the first time.
func _ready():
	$Input.focus_neighbour_left = focus_neighbour_left
	$Input.focus_neighbour_bottom = focus_neighbour_bottom
	$Input.focus_neighbour_right = focus_neighbour_right
	$Input.focus_neighbour_top = focus_neighbour_top
	events = InputMap.get_action_list(realActionName)
	$Input.text = events[0].as_text()
	pass # Replace with function body.

func _input(event):
	if wait_for_input and event.is_pressed() and event is InputEventKey:
		for a in InputMap.get_actions():
			if InputMap.action_has_event(a, event):
				InputMap.action_erase_event(a, event)
				var e = InputMap.get_action_list(a)
				InputMap.action_erase_events(a)
				InputMap.action_add_event(a, events[0])
				for last_e in e:
					InputMap.action_add_event(a, last_e)
		InputMap.action_erase_events(realActionName)
		InputMap.action_add_event(realActionName, event)
		for last_e in events:
			if last_e != events[0]:
				InputMap.action_add_event(realActionName, last_e)
		$Input.text = event.as_text()
		$Input.pressed = false
		wait_for_input = false
	events = InputMap.get_action_list(realActionName)
	$Input.text = events[0].as_text()

func _on_Input_toggled(button_pressed):
	if button_pressed:
		wait_for_input = true
	else:
		wait_for_input = false


func _on_Input_mouse_exited():
	$Input.pressed = false
	wait_for_input = false
