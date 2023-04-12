class_name MoveToNode extends Step

@export var speed := 4.0
@export var time := 60

@export var node: Node2D

var timer := 0

func start() -> bool:
	timer = 0
	return false

func run(delta: float) -> bool:
	actor.direction = actor.global_position.direction_to(node.global_position)
	# actor.velocity = actor.move
	
	return timer > time
