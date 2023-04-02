class_name PlayerInRange extends Group

@export var detection_range := 4.

func start() -> bool:
	if not is_instance_valid(Game.player): return true
	
	var distance_sqr := actor.global_position.distance_squared_to(Game.player.global_position)
	return distance_sqr > (detection_range*16)*(detection_range*16) or super.start()
