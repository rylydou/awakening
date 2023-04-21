extends StaticBody2D

func _ready() -> void:
	if global_position.distance_squared_to(Game.player.position) < 16*16:
		queue_free()
		return
	set_collision_layer_value(2, true)

func take_damage(damage: int, source: Node) -> bool:
	return true

func ignite() -> bool:
	SoundBank.play('low_thud', global_position)
	$DropLoot.trigger()
	queue_free()
	return true
