extends ColorRect

signal animation_finished

func fade_in():
	$AnimationPlayer.play("fade_in")


func _on_AnimationPlayer_animation_finished(_anim_name):
	emit_signal("animation_finished")
