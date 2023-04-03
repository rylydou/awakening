extends Node

const BOOMERANG_SCENE := preload('res://scenes/boomerang.tscn') as PackedScene

var boomerang: Node2D

@onready var player := find_parent('Player') as Player

func check_use() -> bool:
	return not is_instance_valid(boomerang)

func use() -> void:
	assert(check_use())
	
	boomerang = BOOMERANG_SCENE.instantiate() as Node2D
	
	boomerang.direction = player.direction
	boomerang.position = player.position
	
	get_tree().current_scene.add_child(boomerang)
