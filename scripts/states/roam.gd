extends Node

@export var roam_speed := 16.
@onready var actor: Actor = owner

var move_counter := 0

func enter(old_state: Node) -> void:
	actor.animator.play('idle')

func run(delta: float) -> void:
	if move_counter > 0:
		move_counter -= 1
	else:
		move_counter = 60
		
		if Game.player.position.distance_squared_to(actor.global_position) < 64 * 64:
			actor.direction = actor.global_position.direction_to(Game.player.position)
		else:
			actor.direction.x = RNG.ai.randi_range(-1, 1)
			actor.direction.y = RNG.ai.randi_range(-1, 1)
	
	actor.velocity = actor.direction.normalized()*roam_speed
	actor.move_and_slide()
