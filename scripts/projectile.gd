extends CharacterBody2D

enum SpriteMode {
	Single,
	CardinalOnly,
	CardinalAndDiagonal,
}

@export var distance_over_lifetime: Curve
@export var offset_over_lifetime: Curve
@export var lifetime := 120

@export var sprite_mode := SpriteMode.Single

var direction: Vector2
@onready var offset_direction := direction.rotated(PI/2)
@onready var starting_position := position

@onready var sprite: Sprite2D = %Sprite
@onready var collision: CollisionShape2D = %Collision

func _ready() -> void:
	sprite.flip_h = direction.x < 0
	sprite.flip_v = direction.y < 0
	match sprite_mode:
		SpriteMode.CardinalOnly:
			sprite.frame = 0 if direction.x == 0 else 1
		SpriteMode.CardinalAndDiagonal:
			if abs(direction.x) >= .5 and abs(direction.y) >= .5:
				sprite.frame = 1
			else:
				sprite.frame = 0 if direction.x == 0 else 2
	collision.rotation = direction.angle() - PI/2

var age := 0
func _physics_process(delta: float) -> void:
	if age >= lifetime:
		die()
		return
	if test_move(transform, Vector2.ZERO):
		die()
		return
	
	var ratio := float(age)/lifetime
	var distance := distance_over_lifetime.sample_baked(ratio)
	var offset := 0.
	if offset_over_lifetime:
		offset = offset_over_lifetime.sample_baked(ratio)
	
	position = starting_position + direction*distance*16 + offset_direction*offset*16
	
	age += 1

func die() -> void:
	queue_free()
