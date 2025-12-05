extends CanvasLayer


func _ready():
	GameEvents.player_damaged.connect(on_player_damaged)
	reset_vignette()


func _exit_tree():
	reset_vignette()


func reset_vignette():
	if $AnimationPlayer.is_playing():
		$AnimationPlayer.stop()
	var material = $ColorRect.material as ShaderMaterial
	if material:
		material.set_shader_parameter("vignette_intensity", 0.682)
		material.set_shader_parameter("vignette_opacity", 0.115)
		material.set_shader_parameter("vignette_rgb", Color(0.247059, 0.14902, 0.192157, 1))


func on_player_damaged():
	$AnimationPlayer.play("hit")
