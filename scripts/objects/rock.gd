extends Node2D

@export var flag_name := &''

func _ready() -> void:
	if Flags.has(flag_name):
		queue_free()
		return
	process_mode = Node.PROCESS_MODE_INHERIT

func take_damage(damage: int, source: Node) -> bool:
	Flags.raise(flag_name)
	SoundBank.play_ui('unlock')
	queue_free()
	return true
