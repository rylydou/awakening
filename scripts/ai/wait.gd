class_name Wait extends Step

@export var duration := 60

var timer := 0

func start() -> bool:
	timer = duration
	return timer <= 0

func tick(delta: float) -> bool:
	timer -= 1
	return timer <= 0
