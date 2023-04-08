extends Node

@export var scene: PackedScene
@export var offset: Vector2
@export var stun_time := 0

func trigger() -> void:
	var node := scene.instantiate() as Node2D
	node.global_position = owner.global_position + offset
	for group in owner.get_groups():
		node.add_to_group(group)
	if stun_time > 0:
		node.stun_timer = stun_time
	get_tree().current_scene.add_child(node)
