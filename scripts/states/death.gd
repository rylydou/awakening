extends Node

@export var knockback_speed := 128. + 64
@export var sound := 'death'

@onready var actor: Actor = owner
@onready var my_animation_player: AnimationPlayer = $AnimationPlayer

var damage_source: Node2D
var knockback_direction := Vector2.UP 

func enter(old_state: Node) -> void:
	knockback_direction = Vector2.ZERO
	if is_instance_valid(damage_source):
		knockback_direction = damage_source.global_position.direction_to(actor.global_position)
	
	actor.play_sound(sound)
	
	my_animation_player.animation_finished.connect(func(anim_name: StringName): _on_anim_finish(), CONNECT_ONE_SHOT)
	my_animation_player.play('hurt')
	
	actor.collision_layer = 0
	actor.collision_mask = 0
	
	for child in get_children():
		if child.has_method('trigger'):
			child.call('trigger')

func run(delta: float) -> void:
	actor.position += knockback_direction*knockback_speed*delta

func _on_anim_finish() -> void:
	actor.queue_free()

func take_damage(damage: int, source: Node) -> bool:
	return false
