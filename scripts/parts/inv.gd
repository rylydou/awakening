extends Node

@export var time := 60

func trigger() -> void:
	owner.inv_timer = time
