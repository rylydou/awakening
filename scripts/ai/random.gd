class_name Random extends Group

@export var numerator := 1
@export var denominator := 2

func start() -> bool:
	return RNG.ai.randi_range(0, denominator) <= numerator or super.start()
