extends Node

signal textures_generated
var textures_generated = false setget set_tex_gen

var nb_vending_machine_textures = 10
var vending_machine_textures = []

var nb_can_textures = 20
var can_textures = []

var setting_reticle = false setget set_setting_reticle

var paused = true
var display_HUD = false
var display_FPS = false
var display_reticle = false setget set_reticle

func set_setting_reticle(s):
	display_reticle = s
	setting_reticle = s

func set_reticle(s):
	if setting_reticle:
		display_reticle = s

func set_tex_gen(v):
	textures_generated = v
	emit_signal("textures_generated")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

