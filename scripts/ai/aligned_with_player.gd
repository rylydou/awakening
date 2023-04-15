class_name AlignedWithPlayer extends Group

func start() -> bool:
	var aligned = false
	var diff := abs(actor.global_position - Game.player.position) as Vector2
	
	if diff.x < 16.0:
		aligned = true
	elif diff.y < 16.0:
		aligned = true
	
	return not aligned or super.start()
