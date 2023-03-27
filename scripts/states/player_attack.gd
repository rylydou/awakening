extends Node

@export var speed := 64.

@onready var player: Player = owner

var is_active := false

func enter(old_state: Node) -> void:
	is_active = true
	player.animator.speed_scale = 1
	player.animator.animation_finished.connect(
		func(anim_name: StringName):
			if anim_name.begins_with('sword_swing') and is_active:
				_on_anim_finish()
	, CONNECT_ONE_SHOT)
	if not player.animator.play_directional('sword_swing'):
		SoundBank.play('error', player.position)
		_on_anim_finish()

func _on_anim_finish() -> void:
	player.state_machine.exit_state()

func exit(new_state: Node) -> void:
	is_active = false
