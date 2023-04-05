extends Node

@export var sound := 'death'

@onready var player: Player = owner

var damage_source: Node2D
func enter(old_state: Node) -> void:
	player.play_sound(sound)
	
	player.animator.speed_scale = 1
	player.animator.animation_finished.connect(func(anim_name: StringName): _on_anim_finish(), CONNECT_ONE_SHOT)
	player.animator.play_anim('death', Animator.AnimationType.Single)
	
	player.collision_layer = 0
	player.collision_mask = 0
	
	Input.start_joy_vibration(0, .2, .2, .5)

func _on_anim_finish() -> void:
	Game.player_died.emit()
	owner.set_process(false)
	owner.set_physics_process(false)

func take_damage(damage: int, source: Node) -> bool:
	return false
