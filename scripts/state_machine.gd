class_name StateMachine extends Node

@export var base_state: Node

var state_override: Node

func start() -> void:
	var state := get_state()
	if state.has_method('enter'):
		state.call('enter', null)

func get_state() -> Node:
	return state_override if is_instance_valid(state_override) else base_state

func enter_state(new_state: Node) -> void:
	var old_state := get_state()
	if is_instance_valid(old_state) and old_state.has_method('exit'):
		old_state.call('exit', new_state)
	
	state_override = new_state
	
	if new_state.has_method('enter'):
		new_state.call('enter', old_state)

func exit_state() -> void:
	assert(is_instance_valid(state_override), 'cannot exit any more states')
	
	var old_state := state_override
	var new_state := base_state
	if is_instance_valid(old_state) and old_state.has_method('exit'):
		old_state.call('exit', new_state)
	
	state_override = new_state
	
	if new_state.has_method('enter'):
		new_state.call('enter', old_state)

func run(delta: float) -> void:
	var state := get_state()
	
	if is_instance_valid(state) and state.has_method('run'):
		state.call('run', delta)
