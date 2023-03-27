class_name Player extends CharacterBody2D

signal direction_changed(direction: Vector2)

@export var action_buffer_ticks := 5

@onready var defualt_state: Node = $States/Move
@onready var current_state: Node

@onready var animator: Animator = %Animator

var direction := Vector2.DOWN

func _ready() -> void:
	enter_state(defualt_state)

var input_move := Vector2.ZERO
var input_action_buffer := 0
func _process(delta: float) -> void:
	input_move.x = Input.get_axis('move_left', 'move_right')
	input_move.y = Input.get_axis('move_up', 'move_down')
	
	if input_action_buffer > 0:
		input_action_buffer -= 1
	if Input.is_action_just_pressed('action_a'):
		input_action_buffer = action_buffer_ticks

func _physics_process(delta: float) -> void:
	assert(current_state, 'there is no active state')
	if current_state.has_method('run'):
		current_state.call('run', delta)

func enter_state(state: Node) -> void:
	prints('entering state', state.name)
	var previous_state = current_state
	if is_instance_valid(previous_state) and previous_state.has_method('exit'):
		previous_state.call('exit', state)
	
	current_state = state
	if current_state.has_method('enter'):
		current_state.call('enter', previous_state)

func update_direction_to_input() -> void:
	if input_move.y != 0:
		if input_move.y >= 0:
			direction = Vector2.DOWN
		else:
			direction = Vector2.UP
	elif input_move.x != 0:
		if input_move.x >= 0:
			direction = Vector2.RIGHT
		else:
			direction = Vector2.LEFT
	direction_changed.emit()
