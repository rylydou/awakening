class_name Actor extends Node2D

signal died()
signal damaged()

@export_placeholder('Enter an id for this actor...') var id := ''

@export var base_health := 1
@onready var health := base_health

@export var hurt_state: Node

@onready var state_machine: StateMachine = %StateMachine
@onready var animator: Animator = %Animator

var direction := Vector2.DOWN

func _physics_process(delta: float) -> void:
	state_machine.run(delta)

func take_damage(damage: int, source: Node) -> bool:
	print('took damage')
	var current_state := state_machine.current_state
	
	if is_instance_valid(current_state) and current_state.has_method('take_damage'):
		var took_damage := current_state.call('take_damage', damage, source) as bool
		if took_damage:
			damaged.emit()
		return took_damage
	
	damaged.emit()
	
	health -= damage
	if health <= 0:
		died.emit()
		queue_free()
		return true
	
	hurt_state.damage_source = source
	state_machine.push_state(hurt_state)
	return true

func play_sound(sound_name: StringName) -> void:
	SoundBank.play(sound_name + '.' + id, global_position)
