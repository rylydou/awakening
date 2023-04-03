extends Node

func trigger() -> void:
	for child in get_children():
		if child.has_method('trigger'):
			child.call('trigger')
