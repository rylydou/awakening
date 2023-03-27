extends Node

@export var tile_size := 16
@export var screen_size_tiles := Vector2i(11, 11)

var coords := Vector2i.ZERO
var camera_target := Vector2.ZERO

@onready var camera: Camera2D = %Camera

func _process(delta: float) -> void:
	camera.position = camera.position.move_toward(camera_target, 320*delta)

func _on_bounds_area_body_exited(player: Player) -> void:
	if player.position.x >= %Camera.position.x + 90:
		coords.x += 1
	elif player.position.x <= %Camera.position.x - 90:
		coords.x -= 1
	if player.position.y >= %Camera.position.y + 90:
		coords.y += 1
	elif player.position.y <= %Camera.position.y - 90:
		coords.y -= 1
	camera_target = coords*screen_size_tiles*tile_size
	#prints(coords, %Camera.position)
