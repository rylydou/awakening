class_name Move extends Step

@export var distance := 6.
@export var time := 60

var timer := 0

func start() -> bool:
	var speed := (distance*16)/(time/60.)
	actor.velocity = actor.direction*speed
	
	timer = time
	
	return false

func tick(delta: float) -> bool:
	actor.move_and_slide()
	timer -= 1
	return timer <= 0
