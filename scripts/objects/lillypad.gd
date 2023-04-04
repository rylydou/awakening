class_name Lillypad extends PathFollow2D

enum State {
	RunningOnTrack,
	AtEndOfTrack,
	Free,
}

@export var speed := 1.

@export var wave_amp := 1.
@export var wave_rate := 1.
@export var wave_offset := 0.

@export var sprite: Sprite2D

var state := State.RunningOnTrack
var state_timer := 0

var is_player_riding := false

@onready var previous_position: Vector2 = global_position
func _physics_process(delta: float) -> void:
	var is_player_riding := false
	if is_instance_valid(Game.player):
		is_player_riding = Game.player.position.distance_squared_to(global_position) <= 20*20
	
	sprite.offset.y = 0 if is_player_riding else 1
	
	state_timer += 1
	
	match state:
		State.RunningOnTrack:
			progress += speed*16*delta
			if progress_ratio >= 1:
				state = State.AtEndOfTrack
				state_timer = 0
				return
		State.AtEndOfTrack:
			modulate.a = 1. if state_timer%2 == 0 else .5
			if state_timer > 60:
				queue_free()
				return
		State.Free:
			if is_player_riding:
				state_timer = 0
			modulate.a = 1. if state_timer%2 == 0 else .5
			if state_timer > 60:
				queue_free()
				return
	
	var motion := global_position - previous_position
	if is_player_riding:
		Game.player.position += motion
	previous_position = global_position
