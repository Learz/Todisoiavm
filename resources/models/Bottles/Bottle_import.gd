tool # Needed so it runs in editor
extends EditorScenePostImport

# This sample changes all node names
var _scene

# Called right after the scene is imported and gets the root node
func post_import(scene):
	# Change all node names to "modified_[oldnodename]"
	_scene = scene
	iterate(scene)
	return scene # Remember to return the imported scene

func iterate(node):
	if node != null:
		if node.name == _scene.name and node != _scene:
			node.name = "Container"
		if node.name == _scene.name + " Cap":
			node.name = "Cap"
		for child in node.get_children():
			iterate(child)
