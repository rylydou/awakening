class_name Region extends Node

const DESPAWN_GROUP := &'despawn'

func setup() -> void:
	Region.setup_children(self)

static func setup_children(node: Node) -> void:
	for child in node.get_children():
		if child is InstancePlaceholder:
			var instance := child.create_instance() as Node
			instance.add_to_group(DESPAWN_GROUP)
			continue
		
		if child.has_method('setup'):
			child.call('setup')
			continue

static func setup_node(node: Node) -> Node:
	if node is InstancePlaceholder:
		var instance := node.create_instance() as Node
		instance.add_to_group.call_deferred(DESPAWN_GROUP)
		return instance
	
	if node.has_method('setup'):
		node.call('setup')
		return null
	return null
