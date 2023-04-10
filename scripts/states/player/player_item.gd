extends Node

@onready var player: Player = owner
@onready var item_sprite: Sprite2D = %ItemSprite
@onready var item_hitbox: Hitbox = %ItemHitbox

var is_active := false
var index := -1

var spec_nodes := {}
func get_spec_node(item: Item) -> Node:
	var item_id := item.id
	
	if spec_nodes.has(item_id):
		return spec_nodes[item_id]
	
	var spec_node: Node = null
	
	var script := item.item_specifics_script
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
		fail()
		return
	
	var item := ItemDB.get_item(item_id) as Item
	
	if Inventory.magic < item.magic_cost:
		fail()
		return
	
	Inventory.magic -= item.magic_cost
	
	var spec_node := get_spec_node(item)
	
	var can_use := true
	if spec_node and spec_node.has_method('check_use'):
		can_use = spec_node.call('check_use') as bool
	
	if not can_use:
		fail()
		return
	
	item_sprite.region_rect.position = item.item_fx_region.position*16.
	item_sprite.region_rect.size = item.item_fx_region.size*16.
	item_sprite.hframes = item.item_fx_region.size.x
	item_sprite.vframes = item.item_fx_region.size.y
	item_hitbox.damage = item.hitbox_damage
	item_hitbox.forget_hits()
	
	if not item.sound_effect_name.is_empty():
		SoundBank.play(item.sound_effect_name, player.position)
	
	player.animator.speed_scale = 1
	player.animator.play('RESET')
	player.animator.animation_finished.connect(_on_anim_finish, CONNECT_ONE_SHOT)
	
	var found_animation := player.animator.play_anim(item.animation_name, item.animation_type)
	
	if not found_animation:
		player.play_sound('error')
		finish()
	
	if spec_node and spec_node.has_method('use'):
		spec_node.call('use')

func _on_anim_finish(anim_name: StringName) -> void:
	if not is_active: return
	finish()

func fail() -> void:
	player.play_sound('item_drop')
	finish()

func finish() -> void:
	player.state_machine.exit_state()

func exit(new_state: Node) -> void:
	is_active = false
