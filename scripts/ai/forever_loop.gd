class_name ForeverLoop extends Group

func tick(delta: float) -> bool:
	var is_finished := super.tick(delta)
	if is_finished:
		super.start()
	return false
