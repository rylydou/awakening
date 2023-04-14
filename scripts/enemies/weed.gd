extends CharacterBody2D

signal died()

@export var speed := 5.0

var direction: Vector2

func _ready() -> void:
	direction = Vector2.from_angle(RNG.ai.randi_range(0, 4)*PI/2 + PI/4)

func _physics_process(delta: float) -> void:
	var motion := direction*speed*16
	var hit := move_and_collide(motion*delta)
	var hit_normal := Vector2.ZERO
	
	if hit:
		hit_normal = hit.get_normal()
	else:
		if global_position.x > Camera.position.x + Consts.ROOM_SIZE_PX.x/2 - 8:
			hit_normal.x = -1
		if global_position.x < Camera.position.x - Consts.ROOM_SIZE_PX.x/2 + 8:
			hit_normal.x = 1
		if global_position.y > Camera.position.y + Consts.ROOM_SIZE_PX.y/2 - 8:
			hit_normal.y = -1
		if global_position.y < Camera.position.y - Consts.ROOM_SIZE_PX.y/2 + 8:
			hit_normal.y = 1
	
	if not hit_normal.is_zero_approx():
		if hit_normal.x != 0:
			direction.x *= -1
		else:
			direction.y *= -1
		motion = direction*speed*16
		position += motion*delta

func take_damage(damage: int, source: Node) -> bool:
	died.emit()
	queue_free()
	SoundBank.play('clean_cut', global_position)
	return true
