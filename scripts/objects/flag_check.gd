extends Node

@export var flag_name: StringName 
@export var invert := false

func setup() -> bool:
	if Flags.has(flag_name) == invert:
		queue_free()
		return false
	
	for child in get_children():
		if child is InstancePlaceholder:
			var inst := child.create_instance() as Node2D
			inst.add_to_group('despawn')
			continue
		
		if child.has_method('setup'):
			child.call('setup')
	return true
