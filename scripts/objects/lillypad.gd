class_name Lillypad extends StaticBody2D

@onready var sprite: Sprite2D = %Sprite

@export var speed := 2

@export var wave_amp := 1.
@export var wave_rate := 1.
@export var wave_offset := 0.

var age: float
func _process(delta: float) -> void:
	var wave = sin(age*wave_rate*2*PI)*wave_amp+wave_offset
	var player_on_top: bool = Game.player.position.distance_squared_to(global_position) <= 20*20
	sprite.offset.y = 0 if player_on_top else wave
	
	age += delta

func _physics_process(delta: float) -> void:
	position += Vector2.RIGHT*speed*delta
