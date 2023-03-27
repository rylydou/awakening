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
		actor.direction.x = randi_range(-1, 1)
		actor.direction.y = randi_range(-1, 1)
	
	actor.velocity = actor.direction.normalized()*roam_speed
	actor.move_and_slide()
