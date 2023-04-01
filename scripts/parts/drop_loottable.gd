extends Node

@export var lottable: Loottable

func trigger() -> void:
	if not is_instance_valid(lottable): return
	
	var scene := lottable.pick()
	if not is_instance_valid(scene): return
	
	var node := scene.instantiate() as Node2D
	node.position = owner.global_position
	get_tree().current_scene.add_child(node)
