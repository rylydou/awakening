extends Node

@onready var player: Player = owner
@onready var item_sprite: Sprite2D = %ItemSprite
@onready var item_hitbox: Hitbox = %ItemHitbox

var is_active := false
var index := -1

var spec_nodes := {}
func get_spec_node(item_info: ItemInfo) -> Node:
	var item_id := item_info.id
	
	if spec_nodes.has(item_id):
		return spec_nodes[item_id]
	
	var spec_node: Node = null
	
	var script := item_info.item_specifics_script
	if is_instance_valid(script):
		spec_node = Node.new()
		spec_node.set_script(script)
		add_child(spec_node)
	
	spec_nodes[item_id] = spec_node
	return spec_node

func enter(old_state: Node) -> void:
	assert(index >= 0)
	
	is_active = true
	
	var item_id := Inventory.items[index] as StringName
	if item_id.is_empty():
		# no item equiped in that slot
		player.play_sound('item_drop')
		finish()
		return
	
	var item_info := ItemDB.get_item(item_id)
	var spec_node := get_spec_node(item_info)
	
	var can_use := true
	if spec_node and spec_node.has_method('check_use'):
		can_use = spec_node.call('check_use') as bool
	
	if not can_use:
		finish()
		player.play_sound('item_drop')
		return
	
	item_sprite.region_rect.position = item_info.item_fx_region.position*16.
	item_sprite.region_rect.size = item_info.item_fx_region.size*16.
	item_sprite.hframes = item_info.item_fx_region.size.x
	item_sprite.vframes = item_info.item_fx_region.size.y
	item_hitbox.damage = item_info.hitbox_damage
	item_hitbox.forget_hits()
	
	player.animator.speed_scale = 1
	player.animator.play('RESET')
	player.animator.animation_finished.connect(_on_anim_finish, CONNECT_ONE_SHOT)
	
	var found_animation := player.animator.play_anim(item_info.animation_name, item_info.animation_type)
	
	if not found_animation:
		player.play_sound('error')
		finish()
	
	if spec_node and spec_node.has_method('use'):
		spec_node.call('use')

func _on_anim_finish(anim_name: StringName) -> void:
	if not is_active: return
	finish()

func finish() -> void:
	player.state_machine.exit_state()

func exit(new_state: Node) -> void:
	is_active = false
