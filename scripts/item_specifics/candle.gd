extends Node

var fog_max := 0.4
var fog_min := 0.1

var fog := 0.1
func use() -> void:
	fog = fog_max

func _physics_process(delta: float) -> void:
	fog = move_toward(fog, fog_min, 0.01*delta)
	RenderingServer.global_shader_parameter_set('FOG_RADIUS', fog)
