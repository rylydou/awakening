class_name Player extends Actor

@export var action_buffer_ticks := 5

func _enter_tree() -> void:
	Game.fetch.connect(_fetch)
	Game.store.connect(_store)

func _fetch(ds: DataStore) -> void:
	ds.push_prefix('player')
	base_health = ds.fetch_int('max_health', base_health)
	health = ds.fetch_int('health', base_health)
	position = ds.fetch_vec2('position', position)
	ds.pop_prefix()

func _store(ds: DataStore) -> void:
	ds.push_prefix('player')
	ds.store('max_health', base_health)
	ds.store('health', health)
	ds.store('position', position)
	ds.pop_prefix()

func _ready() -> void:
	Camera.target_room()
	Camera.center_camera()

var input_move := Vector2.ZERO
var input_action_buffer := 0
var input_action_index := -1
func _process(delta: float) -> void:
	if input_action_buffer > 0:
		input_action_buffer -= 1
	
	input_move = Vector2.ZERO
	if not Game.player_has_control: return
	if Game.pause_locks > 0: return
	if health <= 0: return
	
	input_move.x = Input.get_axis('move_left', 'move_right')
	input_move.y = Input.get_axis('move_up', 'move_down')

func _unhandled_input(event: InputEvent) -> void:
	if not Game.player_has_control: return
	if Game.pause_locks > 0: return
	if health <= 0: return
	
	if event.is_action_pressed('action_a'):
		get_viewport().set_input_as_handled()
		input_action_index = 0
		input_action_buffer = action_buffer_ticks
		return
	
	if event.is_action_pressed('action_b'):
		get_viewport().set_input_as_handled()
		input_action_index = 1
		input_action_buffer = action_buffer_ticks
		return
	
	if event.is_action_pressed('action_c'):
		get_viewport().set_input_as_handled()
		input_action_index = 2
		input_action_buffer = action_buffer_ticks
		return

func update_direction_to_input() -> void:
	# favor the direction you are inputting on controller -or- prefer vertical on arrow keys or d-pad
	if input_move != Vector2.ZERO:
		if abs(input_move.y) >= abs(input_move.x):
			direction = Vector2.DOWN*sign(input_move.y)
		else:
			direction = Vector2.RIGHT*sign(input_move.x)

@export_group('Cheats')
@export var teleport_shortcut: Shortcut
@export var noclip_shortcut: Shortcut
@export var heal_shortcut: Shortcut
@export var hurt_shortcut: Shortcut
@export var kill_shortcut: Shortcut
func _shortcut_input(event: InputEvent) -> void:
	if not OS.is_debug_build(): return
	if not event.is_pressed(): return
	
	if teleport_shortcut.matches_event(event):
		get_viewport().set_input_as_handled()
		print('CHEAT: Teleport')
		global_position = get_global_mouse_position()
		return
	
	if noclip_shortcut and noclip_shortcut.matches_event(event):
		get_viewport().set_input_as_handled()
		print('CHEAT: Collision enabled? %s' % not get_collision_mask_value(1))
		set_collision_mask_value(1, not get_collision_mask_value(1))
		return
	
	if heal_shortcut.matches_event(event):
		get_viewport().set_input_as_handled()
		print('CHEAT: Heal')
		health = base_health
		return
	
	if hurt_shortcut.matches_event(event):
		get_viewport().set_input_as_handled()
		print('CHEAT: Hurt')
		take_damage(1, self)
		return
	
	if kill_shortcut.matches_event(event):
		get_viewport().set_input_as_handled()
		print('CHEAT: Kill')
		take_damage(health, self)
		return
