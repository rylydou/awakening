extends StaticBody2D

@export var flag_name := &''

func take_damage(damage: int, source: Node) -> bool:
	SoundBank.play('blocked', global_position)
	return true

func explode() -> void:
	Flags.raise(flag_name)
	SoundBank.play_ui('unlock')
	queue_free()
