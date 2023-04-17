extends Node

@export var scene: PackedScene
@export var offset: Vector2
@export var stun_time := 0

func trigger() -> void:
	var node := scene.instantiate() as Node2D
	node.add_to_group('despawn')
	node.position = owner.position + offset
	if stun_time > 0:
		node.stun_timer = stun_time
	owner.get_parent().add_child(node)
