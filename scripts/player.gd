class_name Player extends Actor

@onready var fall_detector_area: Area2D = %FallDetectorArea
@onready var floor_detector_area: Area2D = %FloorDetectorArea

@export var hit_inv_time := 60
@export var spawn_inv_time := 60
@export var respawn_inv_time := 30

@export var action_buffer_ticks := 5

var facing_direction := Vector2i.DOWN
var godmode := false

func _enter_tree() -> void:
	Game.fetch.connect(_fetch)
	Game.store.connect(_store)
	
	#Camera.room_entered.connect(func(room_coords: Vector2i): respawn_position = position)

func _fetch(ds: DataStore) -> void:
	ds.push_prefix('player')
	base_health = ds.fetch('max_health', base_health)
	health = ds.fetch('health', base_health)
	if ds.has('position'):
		position = ds.fetch('position')
	else:
		position = get_tree().current_scene.find_child('Start').position
	ds.pop_prefix()
	
	respawn_position = position
	inv_timer = spawn_inv_time

func _store(ds: DataStore) -> void:
	ds.push_prefix('player')
	ds.store('max_health', base_health)
	ds.store('health', health)
	ds.store('position', position)
	ds.pop_prefix()

var respawn_position := Vector2.ZERO
func respawn() -> void:
	position = respawn_position
	inv_timer = respawn_inv_time

var input_move := Vector2.ZERO
var input_action_buffer := 0
var input_action_index := -1
func _process(delta: float) -> void:
	if input_action_buffer > 0:
		input_action_buffer -= 1
	
	input_move = Vector2.ZERO
	if Game.pause_locks > 0: return
	if health <= 0: return
	
	if not Game.player_has_control: return
	input_move.x = sign(Input.get_axis('move_left', 'move_right'))
	input_move.y = sign(Input.get_axis('move_up', 'move_down'))

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
			facing_direction = Vector2.DOWN*sign(input_move.y)
		else:
			facing_direction = Vector2.RIGHT*sign(input_move.x)
		
		direction = input_move.normalized()

func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	
	var on_fall := fall_detector_area.has_overlapping_bodies()
	var on_floor := floor_detector_area.has_overlapping_bodies()
	if on_fall and not on_floor and state_machine.state_override != $StateMachine/Drown and not godmode:
		state_machine.enter_state($StateMachine/Drown)
		#respawn()
		#take_damage(fall_damage, self)
	
	if on_floor and not on_fall:
		respawn_position = position
	
	$Flip/BodySprite.modulate.a = 0.33 if (inv_timer/2)%2 else 1.0

func take_damage(damage: int, source: Node) -> bool:
	if godmode: return false
	
	if source == self:
		inv_timer = 0
	
	if inv_timer > 0: return false
	
	var took_damage := super.take_damage(damage, source)
	
	if took_damage:
		inv_timer = hit_inv_time
	return took_damage

@export_group('Cheats')
@export var teleport_shortcut: InputEvent
@export var noclip_shortcut: InputEvent
@export var god_shortcut: InputEvent
@export var heal_shortcut: InputEvent
@export var refill_shortcut: InputEvent
@export var hurt_shortcut: InputEvent
@export var kill_shortcut: InputEvent
@export var quicksave_shortcut: InputEvent
@export var quickload_shortcut: InputEvent

func _shortcut_input(event: InputEvent) -> void:
	if not OS.is_debug_build(): return
	if not event.is_pressed(): return
	
	if teleport_shortcut and teleport_shortcut.is_match(event):
		get_viewport().set_input_as_handled()
		print('CHEAT: Teleport')
		global_position = get_global_mouse_position()
		return
	
	if noclip_shortcut and noclip_shortcut.is_match(event):
		get_viewport().set_input_as_handled()
		print('CHEAT: Collision enabled? %s' % not get_collision_mask_value(1))
		set_collision_mask_value(1, not get_collision_mask_value(1))
		return
	
	if god_shortcut and god_shortcut.is_match(event):
		get_viewport().set_input_as_handled()
		godmode = !godmode
		print('CHEAT: God mode enabled? %s' % godmode)
		return
	
	if heal_shortcut and heal_shortcut.is_match(event):
		get_viewport().set_input_as_handled()
		print('CHEAT: Heal')
		health = base_health
		return
	
	if refill_shortcut and refill_shortcut.is_match(event):
		get_viewport().set_input_as_handled()
		print('CHEAT: Refill magic')
		Inventory.magic = Inventory.max_magic
		return
	
	if hurt_shortcut and hurt_shortcut.is_match(event):
		get_viewport().set_input_as_handled()
		print('CHEAT: Hurt')
		take_damage(1, self)
		return
	
	if kill_shortcut and kill_shortcut.is_match(event):
		get_viewport().set_input_as_handled()
		print('CHEAT: Kill')
		take_damage(health, self)
		return
	
	if quicksave_shortcut and quicksave_shortcut.is_match(event):
		get_viewport().set_input_as_handled()
		print('CHEAT: Quicksave')
		_store(Game.ds)
		return
	
	if quickload_shortcut and quickload_shortcut.is_match(event):
		get_viewport().set_input_as_handled()
		print('CHEAT: Quickload')
		_fetch(Game.ds)
		Game.ds.save_to_cache()
		return
