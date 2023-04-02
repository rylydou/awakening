extends CharacterBody2D

@export var distance_tiles := 6.
@export var outward_ticks := 60
@export var return_ticks := 30

@onready var starting_speed := (distance_tiles*16.)/(outward_ticks/60.)
@onready var outward_acc := starting_speed/(outward_ticks/60.)
@onready var return_acc := starting_speed/(return_ticks/60.)

@export var pickup_distance_px := 16.

@onready var speed := starting_speed
var direction := Vector2.DOWN

@onready var hitbox: Hitbox = %Hitbox

func _ready() -> void:
	direction = direction.normalized()

func _physics_process(delta: float) -> void:
	var was_speed_positive := speed > 0
	
	if speed > 0:
		var motion = direction*speed
		var hit := move_and_collide(motion*delta)
		if hit:
			speed = -speed
	else:
		var direction_to_player := global_position.direction_to(Game.player.global_position)
		
		var motion = direction_to_player*-speed
		position += motion*delta
		
		var distance_to_player_sqr := global_position.distance_squared_to(Game.player.global_position)
		if distance_to_player_sqr <= pickup_distance_px*pickup_distance_px:
			pickup()
			return
	
	var acceleration := outward_acc if speed > 0 else return_acc
	speed -= acceleration*delta
	
	if was_speed_positive and speed <= 0:
		hitbox.forget_hits()

func pickup() -> void:
	queue_free()
