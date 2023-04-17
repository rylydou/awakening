extends Node

var fog := 0.0
var fog_animated := 0.0
@export var fog_curve: Curve
@export var fog_time := 60.0

func _physics_process(delta: float) -> void:
	fog = move_toward(fog, 0.0, 1.0/fog_time*delta)
	fog_animated = lerp(fog_animated, fog, 1 - exp(-1.0*delta))
	var fog_radius := fog_curve.sample_baked(fog_animated)
	RenderingServer.global_shader_parameter_set('FOG_RADIUS', fog_radius)
