extends Node2D

@export var rate := 1.0
@export var target_player := true

func _physics_process(delta: float) -> void:
	if target_player:
		position = Game.player.position
	rotate(rate*PI*2*delta)
