extends Node

@export var save_shortcut: InputEvent
@export var load_shortcut: InputEvent

@export var reload_shortcut: InputEvent
@export var restart_shortcut: InputEvent
@export var spawn_shortcut: InputEvent

@export var give_shortcut: InputEvent

@onready var spawn_dialog: FileDialog = %SpawnDialog
@onready var give_dialog: FileDialog = %GiveDialog

func _shortcut_input(event: InputEvent) -> void:
	if not OS.is_debug_build(): return
	if not event.is_pressed(): return
	
	if save_shortcut and save_shortcut.is_match(event):
		get_viewport().set_input_as_handled()
		print('CHEAT: save')
		Game.save()
		return
	
	if load_shortcut and load_shortcut.is_match(event):
		get_viewport().set_input_as_handled()
		print('CHEAT: load')
		Game.ds.load_from_disk()
		return
	
	if reload_shortcut and reload_shortcut.is_match(event):
		get_viewport().set_input_as_handled()
		print('CHEAT: Reload map')
		get_tree().reload_current_scene()
		return
	
	if restart_shortcut and restart_shortcut.is_match(event):
		get_viewport().set_input_as_handled()
		print('CHEAT: Restart game')
		Game.reload()
		return
	
	if spawn_shortcut and spawn_shortcut.is_match(event):
		get_viewport().set_input_as_handled()
		spawn_dialog.popup_centered()
		return
	
	if give_shortcut and give_shortcut.is_match(event):
		get_viewport().set_input_as_handled()
		give_dialog.popup_centered()
		return

var scene_to_spawn: PackedScene
func _on_scene_dialog_file_selected(path: String) -> void:
	print('CHEAT: Spawn %s' % path)
	scene_to_spawn = load(path.trim_suffix('.remap')) as PackedScene

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
		if not is_instance_valid(scene_to_spawn): return
		get_viewport().set_input_as_handled()
		var node := scene_to_spawn.instantiate()
		if node is Node2D:
			node.position = get_tree().current_scene.get_local_mouse_position()
		
		get_tree().current_scene.add_child(node)
		return

func _on_item_dialog_file_selected(path: String) -> void:
	print('CHEAT: Giving %s' % path)
	var resource := load(path.trim_suffix('.remap')) as Item
	Inventory.give_item(resource.id)
