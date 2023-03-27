class_name StateMachine extends Node

@export var base_state: Node

var current_state: Node
var state_stack: Array[Node] = []

func _ready() -> void:
	if is_instance_valid(base_state):
		set_state_raw(base_state)

func set_state_raw(new_state: Node) -> void:
	var old_state := current_state
	if is_instance_valid(old_state) and old_state.has_method('exit'):
		old_state.call('exit', new_state)
	
	state_stack.clear()
	state_stack.append(new_state)
	current_state = new_state
	
	if new_state.has_method('enter'):
		new_state.call('enter', new_state)

func push_state(new_state: Node) -> void:
	var old_state := current_state
	if is_instance_valid(old_state) and old_state.has_method('exit'):
		old_state.call('exit', new_state)
	
	state_stack.append(new_state)
	current_state = new_state
	
	if new_state.has_method('enter'):
		new_state.call('enter', new_state)

func pop_state() -> void:
	assert(state_stack.size() > 0, 'cannot pop state, popped too many times')
	
	var old_state := state_stack.pop_back() as Node
	var new_state := state_stack.back() as Node
	
	if is_instance_valid(old_state) and old_state.has_method('exit'):
		old_state.call('exit', new_state)
	
	current_state = new_state
	
	if new_state.has_method('enter'):
		new_state.call('enter', old_state)

func run(delta: float) -> void:
	if is_instance_valid(current_state) and current_state.has_method('run'):
		current_state.call('run', delta)
