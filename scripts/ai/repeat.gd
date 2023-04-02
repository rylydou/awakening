class_name Repeat extends Group

@export var count_min := 1
@export var count_max := 0

var count: int

func start() -> bool:
	if count_max == 0:
		count = count_min
	else:
		count = RNG.ai.randi_range(count_min, count_max)
	
	return count <= 0 or super.start()

func tick(delta: float) -> bool:
	var is_finished := super.tick(delta)
	if not is_finished:
		return false
	return decrement()

func decrement() -> bool:
	count -= 1
	if count <= 0:
		return true
	return super.start()
