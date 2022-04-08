extends ScrollContainer

func _input(event):
	if event is InputEventScreenDrag:
		scroll_vertical -= event.relative.y
