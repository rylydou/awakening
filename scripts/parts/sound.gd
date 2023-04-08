extends Node

@export var sound_name := &''

func trigger() -> void:
	SoundBank.play(sound_name, owner.global_position)
