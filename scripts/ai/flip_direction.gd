class_name FlipDirection extends Step

func start() -> bool:
	actor.direction = -actor.direction
	return true
