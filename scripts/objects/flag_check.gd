extends Node

@export var flag_name: StringName 
@export var invert := false

func setup() -> bool:
	prints('check', Flags.has(flag_name))
	if Flags.has(flag_name) == invert: return false
	print('passed')
	
	for child in get_children():
		if child is InstancePlaceholder:
			var inst := child.create_instance() as Node2D
			inst.add_to_group('despawn')
			continue
		
		if child.has_method('setup'):
			child.call('setup')
	return true
