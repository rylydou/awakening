extends Node

@export var save_shortcut: Shortcut
@export var load_shortcut: Shortcut

@export var reload_shortcut: Shortcut
@export var spawn_shortcut: Shortcut

@export var give_shortcut: Shortcut

@onready var spawn_dialog: FileDialog = %SpawnDialog
@onready var give_dialog: FileDialog = %GiveDialog

func _shortcut_input(event: InputEvent) -> void:
	if not OS.is_debug_build(): return
	if not event.is_pressed(): return
	
	if save_shortcut.matches_event(event):
		get_viewport().set_input_as_handled()
		print('CHEAT: save')
		Game.save()
		return
	
	if save_shortcut.matches_event(event):
		get_viewport().set_input_as_handled()
		print('CHEAT: save')
		Game.reload()
		return
	
	if reload_shortcut.matches_event(event):
		get_viewport().set_input_as_handled()
		print('CHEAT: Reload tree')
		get_tree().reload_current_scene()
		return
	
	if spawn_shortcut.matches_event(event):
		get_viewport().set_input_as_handled()
		spawn_dialog.popup_centered()
		return
	
	if give_shortcut.matches_event(event):
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
	var resource := load(path.trim_suffix('.remap')) as ItemInfo
	Inventory.give_item(resource.id)
