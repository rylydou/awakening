extends Node

const BOMB_SCENE := preload('res://scenes/bomb.tscn') as PackedScene

var bomb: Node2D

@onready var player := find_parent('Player') as Player

func check_use() -> bool:
	return Inventory.bombs > 0 and not is_instance_valid(bomb)

func use() -> void:
	assert(check_use())
	
	Inventory.bombs -= 1
	
	bomb = BOMB_SCENE.instantiate() as Node2D
	
	#bomb.direction = player.facing_direction
	bomb.position = player.position + player.facing_direction*16.
	
	get_tree().current_scene.add_child(bomb)
