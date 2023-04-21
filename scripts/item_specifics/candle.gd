extends Node

@onready var player: Player = find_parent('Player')
@onready var interation_raycast: RayCast2D = player.find_child('InterationRaycast')

func use() -> void:
	Enviorment.fog = 1.0
	if try_ignite(): return
	var node := preload('res://scenes/fire.tscn').instantiate() as Node2D
	node.position = player.position + player.facing_direction*16.
	get_tree().current_scene.add_child(node)

func try_ignite() -> bool:
	interation_raycast.target_position = player.direction*8
	interation_raycast.force_raycast_update()
	
	if not interation_raycast.is_colliding(): return false
	
	var other := interation_raycast.get_collider() as Node2D
	if not other.has_method('ignite'): return false
	
	return other.call('ignite') as bool
