extends Node

@export var knockback_speed := 64.
@export var sound := 'hurt'

@onready var actor: Actor = owner
@onready var my_animation_player: AnimationPlayer = $AnimationPlayer

var damage_source: Node2D
var knockback_direction := Vector2.UP 

func enter(old_state: Node) -> void:
	knockback_direction = Vector2.ZERO
	if is_instance_valid(damage_source):
		knockback_direction = damage_source.global_position.direction_to(actor.global_position)
	
	actor.play_sound(sound)
	
	my_animation_player.animation_finished.connect(func(anim_name: StringName): _on_anim_finish(), CONNECT_ONE_SHOT)
	my_animation_player.play('hurt')
	Input.start_joy_vibration(0, .1, .1, .1)

func run(delta: float) -> void:
	actor.move_and_collide(knockback_direction*knockback_speed*delta)

func _on_anim_finish() -> void:
	actor.state_machine.exit_state()
