extends Node2D

@onready var rooms_node: Node2D = %Rooms

func _ready() -> void:
	Camera.room_entered.connect(_on_room_entered)
	_on_room_entered(Camera.room_coords)

func _on_room_entered(coords: Vector2i) -> void:
	get_tree().call_group('despawn', 'queue_free')
	
	var room_string := str(coords.x, ' ', coords.y)
	var room_node := rooms_node.find_child(room_string) as Node
	if not is_instance_valid(room_node):
		printerr('Room not found: %s' % room_string)
		return
	
	for child in room_node.get_children():
		if child is InstancePlaceholder:
			var inst := child.create_instance() as Node2D
			inst.name = '_' + child.name
			inst.add_to_group('despawn')
			continue
		
		if child.has_method('setup'):
			child.call('setup')
