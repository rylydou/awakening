class_name SetDirection extends Step

@export var direciton := Vector2i(0, 0)

func start() -> bool:
	actor.direction = direciton
	return true
