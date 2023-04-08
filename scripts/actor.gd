class_name Actor extends CharacterBody2D

signal died()
signal damaged(damage: int, source: Node)

@export_placeholder('Enter an id for this actor...') var id := ''

@export var base_health := 1
@onready var health := base_health

@export var direction := Vector2.DOWN

@onready var hurt_state: Node = %Hurt
@onready var death_state: Node = %Death
@onready var state_machine: StateMachine = %StateMachine
@onready var animator: Animator = %Animator

var inv_timer := 0

func _ready() -> void:
	state_machine.start()

func _physics_process(delta: float) -> void:
	state_machine.run(delta)
	if inv_timer > 0:
		inv_timer -= 1

func take_damage(damage: int, source: Node) -> bool:
	if health <= 0: return false
	if inv_timer > 0: return false
	
	var state := state_machine.get_state()
	
	if state.has_method('take_damage'):
		var took_damage := state.call('take_damage', damage, source) as bool
		if took_damage:
			damaged.emit()
		return took_damage
	
	damaged.emit(damage, source)
	
	health -= damage
	if health <= 0:
		die(source)
		return true
	
	hurt_state.damage_source = source
	state_machine.enter_state(hurt_state)
	return true

func die(source: Node) -> void:
	died.emit()
	death_state.damage_source = source
	state_machine.enter_state(death_state)

func play_sound(sound_name: StringName) -> void:
	SoundBank.play(sound_name + '.' + id, global_position)
