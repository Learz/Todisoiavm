extends KinematicBody

###################-VARIABLES-####################

# Camera
export var joystick_deadzone := 0.08
export var head_path: NodePath
export var cam_path: NodePath
onready var head: Spatial = get_node(head_path)
onready var cam: Camera = get_node(cam_path)
export var FOV := 80.0
var mouse_axis := Vector2()

var rightHandOrigin : Vector3
var leftHandOrigin : Vector3

# Move
var velocity := Vector3()
var direction := Vector3()
var move_axis := Vector2()
var can_sprint := true
var sprinting := false

# Walk
const FLOOR_NORMAL := Vector3(0, 1, 0)
export var gravity := 30.0
export var walk_speed := 10
export var sprint_speed := 20
export var acceleration := 8
export var deacceleration := 10
export(float, 0.0, 1.0, 0.05) var air_control := 0.3
export var jump_height := 10

# Fly
export var fly_speed := 10
export var fly_accel := 4
var flying := false
var climbing := false

# Slopes
export var floor_max_angle := 45.0

#Phone
var phone_out = false

var vending_mode = false
var dev_mouse_display = false

##################################################

# Called when the node enters the scene tree
func _ready() -> void:
	rightHandOrigin = $Head/Camera/RightHand.translation
	leftHandOrigin = $Head/Camera/LeftHand.translation
	cam.fov = FOV
	Global.player = self


# Called every frame. 'delta' is the elapsed time since the previous frame
func _process(_delta: float) -> void:
	if !Global.paused:
		move_axis.x = Input.get_action_strength("move_forward") - Input.get_action_strength("move_backward")
		move_axis.y = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
		$Head/Camera/RightHand.translation.x = (get_viewport().get_visible_rect().size.x/1280)*rightHandOrigin.x * 720/get_viewport().get_visible_rect().size.y
		$Head/Camera/LeftHand.translation.x = (get_viewport().get_visible_rect().size.x/1280)*leftHandOrigin.x * 720/get_viewport().get_visible_rect().size.y
		
		if !vending_mode:
			camera_rotation()

# Called every physics tick. 'delta' is constant
func _physics_process(delta: float) -> void:
	var rayCollider : Object = $Head/Camera/RayCast.get_collider()
	$"../HUD/ReticleUI/Action".visible = false
	if rayCollider:
		var anchor : Spatial = rayCollider.owner.get_node("Camera_Anchor")
		if anchor:
			$"../HUD/ReticleUI/Action".visible = true
			
			
	if !vending_mode and !Global.paused:
		if flying:
			fly(delta)
		elif climbing:
			climb(delta)
		else:
			walk(delta)


# Called when there is an input event
func _input(event: InputEvent) -> void:
	if !Global.paused:
		#TODO : Drink pickup system (pickup rotate drop throw)
		if event is InputEventMouseMotion and !phone_out:
			mouse_axis = event.relative
		if event.is_action_pressed("phone"):
			move_phone()
		if event.is_action_pressed("fly"):
			flying = !flying
		if event.is_action_pressed("action"):
			move_to_anchor()
		if event.is_action_pressed("mouse_input"):
			dev_mouse_display = !dev_mouse_display
			#if(not phone_out):
			#	screenshot()

func move_phone() -> void:
	phone_out = !phone_out
	$Head/Camera/RightHand/Phone.is_phone_out = phone_out
	set_mouse_mode()
	if phone_out:
		$Head/Viewport/PhoneUI.grab_focus()
	var phonePos = Vector3($Head/Camera/RightHand.translation.x,-0.02,rightHandOrigin.z) if phone_out else Vector3($Head/Camera/RightHand.translation.x,-0.5,rightHandOrigin.z)
	var easeType = Tween.EASE_OUT if phone_out else Tween.EASE_IN
	$Tween.interpolate_property($Head/Camera/RightHand, "translation", null, phonePos, 0.7, Tween.TRANS_BACK, easeType)
	$Tween.start()
	#yield(phoneTween, "tween_all_completed")

func move_to_anchor() -> void:
	var trans_speed = 0.5
	var trans_type = Tween.TRANS_QUART
	if vending_mode:
		#$Head/Camera.global_translate()
		$Tween.interpolate_property($Head/Camera, "translation", null, Vector3(0,0,0), trans_speed, trans_type, Tween.EASE_OUT)
		$Tween.interpolate_property($Head/Camera, "rotation", null, Vector3(0,0,0), trans_speed, trans_type, Tween.EASE_OUT)
		$Tween.start()
		vending_mode = false
	else:
		var rayCollider : Object = $Head/Camera/RayCast.get_collider()
		if rayCollider:
			var anchor : Spatial = rayCollider.owner.get_node("Camera_Anchor")
			if anchor:
#				#$Head/Camera.look_at(anchor.global_transform.origin, Vector3.UP)
#				$Head/Camera.global_transform.origin = anchor.global_transform.origin
#				$Head/Camera.global_transform.basis = anchor.global_transform.basis
				$Tween.interpolate_property($Head/Camera, "global_transform:origin", null, anchor.global_transform.origin, trans_speed, trans_type, Tween.EASE_OUT)
				$Tween.interpolate_property($Head/Camera, "global_transform:basis", null, anchor.global_transform.basis, trans_speed, trans_type, Tween.EASE_OUT)
				$Tween.start()
				vending_mode = true
	set_mouse_mode()

func set_mouse_mode() -> void:
	if(!phone_out and !vending_mode and !dev_mouse_display):
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		Global.display_reticle = true
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		Global.display_reticle = false

func screenshot() -> void:
	for uiElement in get_tree().get_nodes_in_group("UI"):
		uiElement.hide()
	yield(get_tree(), "idle_frame")
	yield(get_tree(), "idle_frame")
	var image = get_viewport().get_texture().get_data()
	image.flip_y()
	var timeDict = OS.get_datetime()
	
	var year = timeDict.year
	var month = timeDict.month
	var day = timeDict.day
	var hour = timeDict.hour
	var minute = timeDict.minute
	var second = timeDict.second
	
	var screenshot_title = ("Photo_%02d%02d%02d_%02d%02d%02d" % [year, month, day, hour, minute, second])
	var dir = Directory.new()
	dir.open("res://")
	if not dir.dir_exists("TODISOIAVM Photos"): 
		dir.make_dir("TODISOIAVM Photos")
	dir.open("TODISOIAVM Photos")
	image.save_png("%s/%s.png" % [dir.get_current_dir(), screenshot_title])
	for uiElement in get_tree().get_nodes_in_group("UI"):
		uiElement.show()

func walk(delta: float) -> void:
	# Input
	direction = Vector3()
	var aim: Basis = get_global_transform().basis
	if move_axis.x >= 0.5:
		direction -= aim.z
	if move_axis.x <= -0.5:
		direction += aim.z
	if move_axis.y <= -0.5:
		direction -= aim.x
	if move_axis.y >= 0.5:
		direction += aim.x
	direction.y = 0
	direction = direction.normalized()
	
	# Jump
	var _snap: Vector3
	if is_on_floor():
		#TO FIX : Makes the player jitter between tiles
		_snap = Vector3(0, -1, 0)
		if Input.is_action_just_pressed("move_jump"):
			_snap = Vector3(0, 0, 0)
			velocity.y = jump_height
	
	# Apply Gravity
	velocity.y -= gravity * delta
	
	# Sprint
	var _speed: int
	if (Input.is_action_pressed("move_sprint") and can_sprint and move_axis.x == 1):
		_speed = sprint_speed
		cam.set_fov(lerp(cam.fov, FOV * 1.05, delta * 8))
		sprinting = true
	else:
		_speed = walk_speed
		cam.set_fov(lerp(cam.fov, FOV, delta * 8))
		sprinting = false
	_speed *= Global.debug_speed_multiplier
	
	# Acceleration and Deacceleration
	# where would the player go
	var _temp_vel: Vector3 = velocity
	_temp_vel.y = 0
	var _target: Vector3 = direction * _speed
	var _temp_accel: float
	if direction.dot(_temp_vel) > 0:
		_temp_accel = acceleration
	else:
		_temp_accel = deacceleration
	if not is_on_floor():
		_temp_accel *= air_control
	# interpolation
	_temp_vel = _temp_vel.linear_interpolate(_target, _temp_accel * delta)
	velocity.x = _temp_vel.x
	velocity.z = _temp_vel.z
	# clamping (to stop on slopes)
	if direction.dot(velocity) == 0:
		var _vel_clamp := 0.25
		if velocity.x < _vel_clamp and velocity.x > -_vel_clamp:
			velocity.x = 0
		if velocity.z < _vel_clamp and velocity.z > -_vel_clamp:
			velocity.z = 0
	
	# Move
#	velocity.y = move_and_slide_with_snap(velocity, _snap, FLOOR_NORMAL, 
#			true, 4, deg2rad(floor_max_angle)).y
	velocity.y = move_and_slide(velocity, FLOOR_NORMAL, 
			true, 4, deg2rad(floor_max_angle)).y

func climb(delta: float) -> void:
	# Input
	direction = Vector3()
	var aim = head.get_global_transform().basis
	if move_axis.x == 1:
		direction -= aim.z
	if move_axis.x == -1:
		direction += aim.z
	if move_axis.y == -1:
		direction -= aim.x
	if move_axis.y == 1:
		direction += aim.x
	direction = direction.normalized()
	
	# Acceleration and Deacceleration
	var target: Vector3 = direction * fly_speed
	velocity = velocity.linear_interpolate(target, fly_accel * delta)
	
	# Move
	velocity = move_and_slide(velocity)

func fly(delta: float) -> void:
	# Input
	direction = Vector3()
	var aim = head.get_global_transform().basis
	if move_axis.x == 1:
		direction -= aim.z
	if move_axis.x == -1:
		direction += aim.z
	if move_axis.y == -1:
		direction -= aim.x
	if move_axis.y == 1:
		direction += aim.x
	direction = direction.normalized()
	
	# Acceleration and Deacceleration
	var target: Vector3 = direction * fly_speed * Global.debug_speed_multiplier
	velocity = velocity.linear_interpolate(target, fly_accel * delta)
	
	# Move
	velocity = move_and_slide(velocity)


func camera_rotation() -> void:	
	var joystick_axis = Vector2(Input.get_joy_axis(0, 2),Input.get_joy_axis(0, 3))
	
	var horizontal:float = 0
	var vertical:float = 0
	
	if joystick_axis.length() > joystick_deadzone:
		horizontal += -(joystick_axis.x * Global.joystick_sensitivity)
		vertical += -(joystick_axis.y * Global.joystick_sensitivity)
	
	if mouse_axis.length() > 0 and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		# Get mouse delta
		horizontal += -(mouse_axis.x * Global.mouse_sensitivity) / Global.mouse_smoothness 
		vertical += -(mouse_axis.y * Global.mouse_sensitivity) / Global.mouse_smoothness 
		
		mouse_axis = Vector2()
		
		rotate_y(deg2rad(horizontal))
		head.rotate_x(deg2rad(vertical))
	
		# Clamp mouse rotation
		var temp_rot: Vector3 = head.rotation_degrees
		temp_rot.x = clamp(temp_rot.x, -90, 90)
		head.rotation_degrees = temp_rot
