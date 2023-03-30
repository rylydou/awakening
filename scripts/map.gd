extends Node2D

func _ready() -> void:
	Camera.room_entered.connect(_on_room_entered)
	_on_room_entered(Camera.room_coords)

func _on_room_entered(coords: Vector2i) -> void:
	get_tree().call_group('respawn', 'queue_free')
	
	var room_string := str(coords.x, ' ', coords.y)
	var room_node := find_child(room_string) as Node
	if not is_instance_valid(room_node):
		printerr('Room not found: %s' % room_string)
		return
	
	for child in room_node.get_children():
		if child is InstancePlaceholder:
			child.create_instance()
