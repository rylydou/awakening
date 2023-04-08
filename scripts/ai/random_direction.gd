class_name RandomDirection extends Step

@export var allow_diagonal := false
@export var offscreen_check_distance := 3.

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
	
	var diff := actor.global_position - Camera.position
	if abs(diff.y) > Consts.ROOM_SIZE_PX.y/2-offscreen_check_distance*16 and sign(diff.y) == sign(y):
		y *= -1
	if abs(diff.x) > Consts.ROOM_SIZE_PX.x/2-offscreen_check_distance*16 and sign(diff.x) == sign(x):
		x *= -1
	
	actor.direction.x = x
	actor.direction.y = y
	
	return true
