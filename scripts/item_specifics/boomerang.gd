extends Node

var boomerang_instance: Node2D

@onready var player := find_parent('Player') as Player

func check_use() -> bool:
	return not is_instance_valid(boomerang_instance)

func use() -> void:
	assert(check_use())
	
	var scene := preload('res://scenes/boomerang.tscn') as PackedScene
	boomerang_instance = scene.instantiate() as Node2D
	
	boomerang_instance.direction = player.direction
	boomerang_instance.position = player.position
	
	get_tree().current_scene.add_child(boomerang_instance)
