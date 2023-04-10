extends Node2D

@onready var rooms_node: Node2D = %Rooms

func _ready() -> void:
	Camera.room_entered.connect(_on_room_entered)
	_on_room_entered(Camera.room_coords)

func _on_room_entered(coords: Vector2i) -> void:
	get_tree().call_group('despawn', 'queue_free')
	
	var room := get_room(coords)
	if not room: return
	
	for child in room.get_children():
		if child is InstancePlaceholder:
			var inst := child.create_instance() as Node2D
			inst.add_to_group('despawn')
			continue
		
		if child.has_method('setup'):
			child.call('setup')

func get_room(coords: Vector2i) -> Node:
	var string := str(coords.x, ' ', coords.y)
	var room := rooms_node.find_child(string) as Node
	if not is_instance_valid(room):
		#printerr('Room not found: %s' % string)
		return null
	return room
