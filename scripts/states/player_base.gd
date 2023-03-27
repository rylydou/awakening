extends Node

@export var speed := 64.

@onready var attack_state: = $'../Attack'

@onready var player: Player = owner

func run(delta: float) -> void:
	player.update_direction_to_input()
	
	player.animator.speed_scale = 1
	player.animator.play_directional('walk')
	player.animator.speed_scale = 1 if player.input_move.length_squared() > 0 else 0
	
	player.velocity = player.input_move.normalized()*speed
	player.move_and_slide()
	
	if player.input_action_buffer > 0:
		player.input_action_buffer = 0
		player.state_machine.enter_state(attack_state)

func exit(new_state: Node) -> void:
	player.animator.speed_scale = 1
	pass
