extends Node2D

@export var time := 1.
@export var start_delay := 0.

@onready var timer := start_delay*60
var node_to_spawn: Node2D

func _enter_tree() -> void:
	node_to_spawn = get_child(0)
	remove_child(node_to_spawn)

func _physics_process(delta: float) -> void:
	timer -= 1
	if timer >= 0: return
	timer = time*60
	spawn()

func spawn() -> void:
	var node := node_to_spawn.duplicate()
	add_child(node)
