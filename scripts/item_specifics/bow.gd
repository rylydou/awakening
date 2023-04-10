extends Node

const ARROW_SCENE := preload('res://scenes/arrow.tscn') as PackedScene

var arrow: Node2D

@onready var player := find_parent('Player') as Player

func check_use() -> bool:
	return not is_instance_valid(arrow)

func use() -> void:
	assert(check_use())
	
	arrow = ARROW_SCENE.instantiate() as Node2D
	
	arrow.direction = player.facing_direction
	arrow.position = player.position
	
	get_tree().current_scene.add_child(arrow)
