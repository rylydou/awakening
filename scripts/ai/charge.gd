class_name Charge extends Step

@export var speed_over_time: Curve
@export var speed_time := 60

var timer := 0
func start() -> bool:
	timer = 0.0
	return false

func tick(delta: float) -> bool:
	timer += 1
	
	var speed := speed_over_time.sample_baked(float(timer)/speed_time)*16
	var motion := actor.direction*speed
	var hit := actor.move_and_collide(motion*delta)
	
	return hit != null
