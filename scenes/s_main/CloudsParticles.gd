extends Spatial

export (Array, Texture) var clouds setget set_clouds
export (int, 0, 500) var particle_amount setget set_particle_amount
export (float) var particle_scale = 40
export (Vector3) var visible_dimensions = Vector3(500,500,100)
export (float) var wind_speed = 2


func set_clouds(s):
	clouds = s
	
func set_particle_amount(s):
	particle_amount = s

# Called when the node enters the scene tree for the first time.
func _ready():
	var vdim = visible_dimensions
	#var particles = []
	for cloud_tex in clouds:
		#Create Particle System
		var parSys = Particles.new()
		parSys.amount = particle_amount / (1 + clouds.size())
		parSys.lifetime = vdim.x / wind_speed
		parSys.preprocess = vdim.x / wind_speed
		parSys.visibility_aabb = AABB(Vector3(-vdim.x/2,-vdim.y,-vdim.z/2), vdim)
		
		#Create Particle Material
		var parMat = ParticlesMaterial.new()
		parMat.emission_shape = ParticlesMaterial.EMISSION_SHAPE_BOX
		parMat.emission_box_extents = Vector3(vdim.y, 10, 0)
		parMat.direction = Vector3(0,-1,0)
		parMat.spread = 0
		parMat.gravity = Vector3(0,0,0)
		parMat.initial_velocity = wind_speed
		var curveTex = CurveTexture.new()
		var curve = Curve.new()
		curve.clear_points()
		curve.add_point(Vector2(0,0),0,0,1,1)
		curve.add_point(Vector2(0.1,1),0,0,1,1)
		curve.add_point(Vector2(0.9,1),0,0,1,1)
		curve.add_point(Vector2(1,0),0,0,1,1)
		curveTex.curve = curve
		parMat.scale_curve = curveTex
		parSys.process_material = parMat
		
		#Create Mesh and Mesh Material
		var mat = SpatialMaterial.new()
		mat.albedo_texture = cloud_tex
		mat.params_use_alpha_scissor = true
		mat.params_alpha_scissor_threshold = 0.5
		var mesh = QuadMesh.new()
		mesh.size = Vector2(particle_scale,particle_scale)
		mesh.material = mat
		parSys.draw_pass_1 = mesh
		
		#Add to tree and array
		add_child(parSys)
	#particles.append(parSys)
	pass # Replace with function body.
