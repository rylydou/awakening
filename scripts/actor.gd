class_name Actor extends CharacterBody2D

signal died()
signal damaged()

@export_placeholder('Enter an id for this actor...') var id := ''

@export var base_health := 1
@onready var health := base_health

@onready var hurt_state: Node = %Hurt
@onready var death_state: Node = %Death
@onready var state_machine: StateMachine = %StateMachine
@onready var animator: Animator = %Animator

var direction := Vector2.DOWN

func _ready() -> void:
	state_machine.start()

func _physics_process(delta: float) -> void:
	state_machine.run(delta)

func take_damage(damage: int, source: Node) -> bool:
	var state := state_machine.get_state()
	
	if state.has_method('take_damage'):
		var took_damage := state.call('take_damage', damage, source) as bool
		if took_damage:
			damaged.emit()
		return took_damage
	
	damaged.emit()
	
	health -= damage
	if health <= 0:
		died.emit()
		death_state.damage_source = source
		state_machine.enter_state(death_state)
		return true
	
	hurt_state.damage_source = source
	state_machine.enter_state(hurt_state)
	return true

func play_sound(sound_name: StringName) -> void:
	SoundBank.play(sound_name + '.' + id, global_position)
