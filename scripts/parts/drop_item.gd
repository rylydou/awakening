extends Node

const SCENE := preload('res://scenes/item_pickup.tscn')

@export var item: Item
@export var there_can_only_be_one := true

func trigger() -> void:
	var node := SCENE.instantiate() as Node2D
	node.item = item
	node.there_can_only_be_one = there_can_only_be_one
	node.position = owner.global_position
	node.add_to_group('despawn')
	get_tree().current_scene.add_child.call_deferred(node)
