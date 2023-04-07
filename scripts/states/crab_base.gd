extends ForeverLoop

@export var speed := 2.

@onready var point_a: Vector2 = actor.global_position
@onready var point_b: Vector2 = actor.marker.global_position
@onready var target := point_b

var is_angry := false

func _ready() -> void:
	actor.damaged.connect(_damaged)
	actor = owner

func run(delta: float) -> void:
	if is_angry:
		tick(delta)
		return
	
	actor.direction = actor.global_position.direction_to(target)
	actor.velocity = actor.direction*speed*16
	actor.move_and_slide()
	
	var reached_target := actor.global_position.distance_squared_to(target) <= actor.velocity.length_squared()*delta*2
	if reached_target:
		if target == point_b:
			target = point_a
		else:
			target = point_b

func _damaged(damage: int, source: Node) -> void:
	is_angry = true
