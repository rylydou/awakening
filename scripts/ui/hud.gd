extends Control

@onready var life_display: IconStatus = %LifeDisplay
@onready var inventory: GridContainer = %ItemGrid

@onready var money_label: Label = %MoneyLabel
@onready var deaths_label: Label = %DeathsLabel
@onready var arrows_label: Label = %ArrowsLabel
@onready var bombs_label: Label = %BombsLabel

@onready var map_marker: Control = %MapMarker
@onready var map_area_label: Label = %MapAreaLabel

var is_equip_menu_open := false

func _enter_tree() -> void:
	Game.fetch.connect(_fetch)

func _fetch(ds: DataStore) -> void:
	deaths_label.text = str(ds.fetch('counter.deaths', 0))

func _process(delta: float) -> void:
	process_cursor(delta)
	
	if is_instance_valid(Game.player):
		life_display.value = Game.player.health
		life_display.max_value = Game.player.base_health
	
	money_label.text = str(Inventory.money)
	arrows_label.text = str(Inventory.arrows)
	bombs_label.text = str(Inventory.bombs)
	
	map_area_label.text = '%2s.%-2s' % [Camera.room_coords.x + 1, Camera.room_coords.y + 1]
	map_marker.position = Camera.room_coords * 8

@onready var cursor: NinePatchRect = %Cursor
var cursor_target: Control
var new_cursor := true
func process_cursor(delta: float) -> void:
	cursor.visible = is_instance_valid(cursor_target)
	if is_instance_valid(cursor_target):
		if new_cursor:
			new_cursor = false
			cursor.position = cursor_target.global_position
			cursor.size = cursor_target.size
		else:
			const LAMDA := 50
			cursor.position = cursor.global_position.lerp(cursor_target.global_position, 1 - exp(-LAMDA*delta))
			cursor.size = cursor.size.lerp(cursor_target.size, 1 - exp(-LAMDA*delta))
	else:
		new_cursor = true

func _unhandled_input(event: InputEvent) -> void:
	if is_equip_menu_open:
		process_equip(event)
		get_viewport().set_input_as_handled()
		return
	
	if event.is_action_pressed('equip'):
		get_viewport().set_input_as_handled()
		SoundBank.play_ui('menu_select1')
		is_equip_menu_open = true
		Game.player_has_control = false
		equip_update_cursor()
		return

var equip_grid_index := 0
func process_equip(event: InputEvent) -> void:
	if event.is_action_pressed('equip'):
		is_equip_menu_open = false
		cursor_target = null
		Game.player_has_control = true
		SoundBank.play_ui('menu_back')
		return
	
	var STRENGTH := .9
	if event.is_action_pressed('move_left') and event.get_action_strength('move_left') > STRENGTH:
		equip_grid_index -= 1
		equip_update_cursor()
		return
	if event.is_action_pressed('move_right') and event.get_action_strength('move_right') > STRENGTH:
		equip_grid_index += 1
		equip_update_cursor()
		return
	if event.is_action_pressed('move_up') and event.get_action_strength('move_up') > STRENGTH:
		equip_grid_index -= inventory.columns
		equip_update_cursor()
		return
	if event.is_action_pressed('move_down') and event.get_action_strength('move_down') > STRENGTH:
		equip_grid_index += inventory.columns
		equip_update_cursor()
		return
	
	if event.is_action_pressed('action_a'):
		SoundBank.play_ui('menu_select2')
		Inventory.swap_items(equip_grid_index + 3, 0)
		return
	if event.is_action_pressed('action_b'):
		SoundBank.play_ui('menu_select2')
		Inventory.swap_items(equip_grid_index + 3, 1)
		return
	if event.is_action_pressed('action_c'):
		SoundBank.play_ui('menu_select2')
		Inventory.swap_items(equip_grid_index + 3, 2)
		return

func equip_update_cursor() -> void:
	equip_grid_index = equip_grid_index%inventory.get_child_count()
	cursor_target = inventory.get_child(equip_grid_index)
