extends Camera2D

@export var tile_size := 16
@export var screen_size_tiles := Vector2i(11, 11)

var target := Vector2.ZERO
var coords := Vector2i.ZERO

func _ready() -> void:
	update_target()
	center_camera()

func _process(delta: float) -> void:
	update_target()
	position = position.move_toward(target, 320*delta)

func center_camera() -> void:
	position = target

func update_target() -> void:
	if not is_instance_valid(Game.player): return
	var player := Game.player.position
	
	if player.x >= position.x + 90:
		coords.x += 1
	elif player.x <= position.x - 90:
		coords.x -= 1
	
	if player.y >= position.y + 90:
		coords.y += 1
	elif player.y <= position.y - 90:
		coords.y -= 1
	
	target = coords*screen_size_tiles*tile_size
