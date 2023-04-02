extends Node

@export var speed := 64.

@export var item_state: Node

@onready var player: Player = owner
@onready var interation_raycast: RayCast2D = %InterationRaycast

func run(delta: float) -> void:
	player.update_direction_to_input()
	
	player.animator.speed_scale = 1
	player.animator.play_anim('walk', Animator.AnimationType.FourDirectional)
	player.animator.speed_scale = 1 if player.input_move.length_squared() > 0 else 0
	
	player.velocity = player.input_move.normalized()*speed
	player.move_and_slide()
	
	if player.input_action_buffer > 0:
		player.input_action_buffer = 0
		
		# Pressed A so try to interact first
		if player.input_action_index == 0:
			if try_interact(): return
		
		item_state.index = player.input_action_index
		player.state_machine.enter_state(item_state)

func exit(new_state: Node) -> void:
	player.animator.speed_scale = 1
	pass

func try_interact() -> bool:
	interation_raycast.target_position = player.direction*8
	interation_raycast.force_raycast_update()
	
	if not interation_raycast.is_colliding(): return false
	
	var other := interation_raycast.get_collider() as Node2D
	if not other.has_method('interact'): return false
	
	return other.call('interact') as bool
