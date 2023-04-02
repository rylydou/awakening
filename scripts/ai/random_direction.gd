class_name RandomDirection extends Step

@export var allow_diagonal := false

func start() -> bool:
	var x := 0
	var y := 0
	
	if allow_diagonal:
		x = 1 if RNG.ai.randi()%2 == 0 else -1
		y = 1 if RNG.ai.randi()%2 == 0 else -1
	else:
		if RNG.ai.randi()%2 == 0:
			x = 1 if RNG.ai.randi()%2 == 0 else -1
		else:
			y = 1 if RNG.ai.randi()%2 == 0 else -1
	
	actor.direction.x = x
	actor.direction.y = y
	
	return true
