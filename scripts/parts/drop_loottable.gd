extends Node

func trigger() -> void:
	var drop_node := preload('res://scenes/money_drop.tscn').instantiate() as Node2D
	drop_node.position = owner.global_position
	get_tree().current_scene.add_child(drop_node)
