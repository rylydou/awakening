extends Area2D

@export var flag_name := &'heart_'

func _ready() -> void:
	if Flags.has(flag_name):
		queue_free()

func _on_body_entered(player: Player) -> void:
	if Flags.has(flag_name): return
	Game.player.base_health += 4
	Game.player.health = Game.player.base_health
	Flags.raise(flag_name)
	queue_free()
