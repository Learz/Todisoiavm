tool # Needed so it runs in editor
extends EditorScenePostImport

# This sample changes all node names
var _scene

# Called right after the scene is imported and gets the root node
func post_import(scene):
	_scene = scene as RigidBody
	_scene.mode = RigidBody.MODE_STATIC
	_scene.linear_damp = 1.0
	_scene.angular_damp = 1.0
	iterate(scene)
	return scene # Remember to return the imported scene

func iterate(node : Node):
	if node != null:
		if node.name == _scene.name and node != _scene:
			node.name = "Container"
			_scene.transform.origin.y = node.get_aabb().size.y/2
			node.transform.origin.y = -node.get_aabb().size.y/2
		if " Cap" in node.name :
			node.name = "Cap"
		if "-cylinderShape" in node.name:
			var dimensions = node.get_aabb()
			var collider = CollisionShape.new()
			collider.transform.origin = node.transform.origin
			collider.name = "Collider"
			var shape = CylinderShape.new()
			shape.radius = dimensions.size.x/2
			shape.height = dimensions.size.y
			collider.transform.origin.y = 0
			collider.shape = shape
			_scene.add_child(collider)
			collider.owner = _scene
			node.queue_free()
		if "-boxShape" in node.name:
			var dimensions = node.get_aabb()
			var collider = CollisionShape.new()
			collider.transform.origin = node.transform.origin
			collider.name = "Collider"
			var shape = BoxShape.new()
			shape.extents = dimensions.size/2
			collider.transform.origin.y = 0
			collider.shape = shape
			_scene.add_child(collider)
			collider.owner = _scene
			node.queue_free()
		for child in node.get_children():
			iterate(child)
