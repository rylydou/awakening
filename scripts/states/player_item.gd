extends Node

@onready var player: Player = owner

var is_active := false
var index := -1

func enter(old_state: Node) -> void:
	assert(index >= 0)
	
	is_active = true
	var item_id := Inventory.items[index] as StringName
	if item_id.is_empty():
		# no item equiped in that slot
		player.play_sound('item_drop')
		_on_anim_finish()
		return
	
	var item_info := ItemDB.get_item(item_id)
	
	player.animator.speed_scale = 1
	player.animator.play('RESET')
	player.animator.animation_finished.connect(
		func(anim_name: StringName):
			if anim_name.begins_with(item_info.animation_name) and is_active:
				_on_anim_finish()
	, CONNECT_ONE_SHOT)
	
	if item_info.directional_animation:
		if not player.animator.play_directional(item_info.animation_name):
			player.play_sound('error')
			_on_anim_finish()
		player.animator.play_directional(item_info.animation_name)
	else:
		player.animator.play(item_info.animation_name)

func _on_anim_finish() -> void:
	player.state_machine.exit_state()

func exit(new_state: Node) -> void:
	is_active = false
