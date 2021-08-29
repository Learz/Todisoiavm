tool
extends Panel

var from_node = null
var from_node_slot = null
var current_node = null
var new_node_pos = Vector2(0,0)

const choice_dialogue = preload("res://addons/dialogue_tree/scripts/ChoiceDialogue.gd")
const basic_dialogue = preload("res://addons/dialogue_tree/scripts/BasicDialogue.gd")
const conditional_dialogue = preload("res://addons/dialogue_tree/scripts/ConditionalDialogue.gd")
const random_dialogue = preload("res://addons/dialogue_tree/scripts/RandomDialogue.gd")
const start_dialogue = preload("res://addons/dialogue_tree/scripts/StartNode.gd")
const end_dialogue = preload("res://addons/dialogue_tree/scripts/EndNode.gd")

func _ready():
	$TopBar/TopContainer/MenuButton.get_popup().connect("id_pressed", self, "_on_menubutton_item_pressed")
	$PopupMenu.connect("id_pressed", self, "new_node_at_position")

# when a button on the add menu is pressed
func _on_menubutton_item_pressed(id):
	var dialogueInstance = null
	match(id):
		0:
			dialogueInstance = load("res://addons/dialogue_tree/scenes/BasicDialogue.tscn").instance()
		1:
			dialogueInstance = load("res://addons/dialogue_tree/scenes/ConditionalDialogue.tscn").instance()
		2:
			dialogueInstance = load("res://addons/dialogue_tree/scenes/ChoiceDialogue.tscn").instance()
		3:
			dialogueInstance = load("res://addons/dialogue_tree/scenes/RandomDialogue.tscn").instance()
			
	dialogueInstance.connect("close_request", self, "_on_node_close", [dialogueInstance])
	dialogueInstance.connect("resize_request", self, "_on_node_resize", [dialogueInstance])
	match(id): 
		2, 3:
			dialogueInstance.connect("removed", self, "remove_connection", [dialogueInstance])
		
	$PrimaryGraphEditor.add_child(dialogueInstance, true)
	return dialogueInstance

# create a graph node at new_node_pos and connect to from_node if it exists
# TODO : Fix slight offset when the position is in negative values
func new_node_at_position(id):
	var dialogueInstance = _on_menubutton_item_pressed(id) as GraphNode
	var pos = ($PrimaryGraphEditor.scroll_offset + new_node_pos) / $PrimaryGraphEditor.get_zoom()
	var snap_dist = $PrimaryGraphEditor.snap_distance
	if($PrimaryGraphEditor.use_snap):
		dialogueInstance.offset = pos - Vector2(fmod(pos.x, snap_dist), fmod(pos.y, snap_dist))
	else:
		dialogueInstance.offset = pos
	if(from_node):
		_on_PrimaryGraphEditor_connection_request(from_node, from_node_slot, dialogueInstance.name, 0)

# when there is a connection request 
func _on_PrimaryGraphEditor_connection_request(from, from_slot, to, to_slot):
	var all_connections = $PrimaryGraphEditor.get_connection_list() 	# {from_port: 0, from: "GraphNode name 0", to_port: 1, to: "GraphNode name 1" }
	var slot_connections = []
	for connection in all_connections:
		if connection["from"] == from and connection["from_port"] == from_slot:
			slot_connections.append(connection)
	for slot_connection in slot_connections:
		$PrimaryGraphEditor.disconnect_node(slot_connection["from"], slot_connection["from_port"], slot_connection["to"], slot_connection["to_port"])
	
	$PrimaryGraphEditor.connect_node(from, from_slot, to, to_slot)

# when there is a disconnection request
func _on_PrimaryGraphEditor_disconnection_request(from, from_slot, to, to_slot):
	$PrimaryGraphEditor.disconnect_node(from, from_slot, to, to_slot)

# when a graph node is closed
func _on_node_close(ref):
	remove_all_connections(ref)
	ref.queue_free()

# when a graph node is resized
func _on_node_resize(newSize, ref):
	ref.rect_size = newSize

# opens a popup menu to create a new node at mouse position
func open_new_popup():
	$PopupMenu.set_position(get_global_mouse_position())
	$PopupMenu.popup()
	
# sets the current node to edit
func set_edit_node(ref):
	clear_all_nodes()
	current_node = ref
	
	if current_node != null and current_node.DialogueResource != null:
		for i in current_node.DialogueResource.Nodes:
			if i["name"] != "StartNode" and i["name"] != "EndNode":
				var newNode = load(i.filename).instance()
				newNode.name = i.name
				newNode.offset = Vector2(i.rect_x, i.rect_y)
				newNode.rect_size = Vector2(i.rect_size_x, i.rect_size_y)
				
				newNode.connect("close_request", self, "_on_node_close", [newNode])
				newNode.connect("resize_request", self, "_on_node_resize", [newNode])
				if newNode is choice_dialogue or newNode is random_dialogue:
					newNode.connect("removed", self, "remove_connection", [newNode])
				
				$PrimaryGraphEditor.add_child(newNode, true)
				
				newNode.load_data(i)
			else:
				var editNode = $PrimaryGraphEditor.get_node(i["name"])
				editNode.offset = Vector2(i["rect_x"], i["rect_y"])
				editNode.rect_size = Vector2(i["rect_size_x"], i["rect_size_y"])
		
		for i in current_node.DialogueResource.connections:
			$PrimaryGraphEditor.connect_node(i.from, i.from_port, i.to, i.to_port)

# saves the resource to the active node
func save_resource():
	# if there is no current resource, create it
	if current_node != null:
		if current_node.DialogueResource == null:
			var newRes = create_resource()
			
			newRes.connections = $PrimaryGraphEditor.get_connection_list()
			
			for i in $PrimaryGraphEditor.get_children():
				if i.has_method("save_data"):
					newRes.Nodes.append(i.save_data())
			
			newRes.DialogueTree = make_exported_dialogue()
			
			ResourceSaver.save(current_node.owner.filename, newRes)
			current_node.DialogueResource = newRes
		else:
			var newRes = current_node.DialogueResource
			newRes.connections = $PrimaryGraphEditor.get_connection_list()
			
			newRes.Nodes.clear()
			
			for i in $PrimaryGraphEditor.get_children():
				if i.has_method("save_data"):
					newRes.Nodes.append(i.save_data())
			
			newRes.DialogueTree = make_exported_dialogue()
			
			ResourceSaver.save(current_node.DialogueResource.resource_path, newRes)

# creates a new dialogue resource
func create_resource():
	var newRes = load("res://addons/dialogue_tree/resource/DialogueRes.tres").duplicate()
	return newRes

# creates a json friendly version of the data for reading
func make_exported_dialogue():
	var exportedDict = {
		"start_index" : 0,
		"dialogue" : []
	}
	
	# add all nodes
	for i in $PrimaryGraphEditor.get_children():
		if i.name != "StartNode" and i.name != "EndNode" and i.has_method("export_values"):
			exportedDict.dialogue.append(i.export_values())
	
	# create connections
	for i in $PrimaryGraphEditor.get_connection_list():
		var fromNode = $PrimaryGraphEditor.get_node(i.from)
		var toNode = $PrimaryGraphEditor.get_node(i.to)
		
		# if we have a starting connection
		if fromNode is start_dialogue:
			var toIndex = find_with_name(exportedDict.dialogue, i.to)
			
			exportedDict.start_index = toIndex
		# for all other node types
		else:
			if fromNode.has_method("make_connection"):
				exportedDict = fromNode.make_connection(i, exportedDict, toNode is end_dialogue)
	
	return exportedDict

# used to find the index of an exported node with a name value
func find_with_name(inArray, inName):
	for i in range(0, inArray.size()):
		if inArray[i].NodeName == inName:
			return i
	
	return -1

# used to clear everything from the graph
func clear_all_nodes():
	$PrimaryGraphEditor.clear_connections()
	for i in $PrimaryGraphEditor.get_children():
		if i is GraphNode and i.name != "StartNode" and i.name != "EndNode":
			i.free()

# removes connections going from an id
func remove_connection(id, node):
	for i in $PrimaryGraphEditor.get_connection_list():
		if i.from == node.name and i.from_port == id:
			$PrimaryGraphEditor.disconnect_node(i.from, i.from_port, i.to, i.to_port)

# used to remove all connections going in or out of a node
func remove_all_connections(node):
	for i in $PrimaryGraphEditor.get_connection_list():
		if i.from == node.name or i.to == node.name:
			$PrimaryGraphEditor.disconnect_node(i.from, i.from_port, i.to, i.to_port)

func _on_PrimaryGraphEditor_connection_to_empty(from, from_slot, release_position):
	new_node_pos = release_position
	from_node = from
	from_node_slot = from_slot
	open_new_popup()

func _on_PrimaryGraphEditor_popup_request(position):
	new_node_pos = position - $PrimaryGraphEditor.rect_global_position 
	open_new_popup()
	
func _on_PopupMenu_popup_hide():
	from_node = null
	from_node_slot = null
	new_node_pos = Vector2(0,0)
