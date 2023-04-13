class_name MoveToNode extends Step

@export var speed := 4.0
@export var time := 60

@export var node: Node2D

var timer := 0

func start() -> bool:
	timer = 0
	return false

func tick(delta: float) -> bool:
	timer += 1
	actor.direction = actor.global_position.direction_to(node.global_position)
	actor.velocity = actor.direction*speed*16
	actor.move_and_slide()
	
	return timer > time
