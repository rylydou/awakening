extends Node

@export var tile_size := 16
@export var screen_size_tiles := Vector2i(11, 11)

var coords := Vector2i.ZERO
var camera_target := Vector2.ZERO

@onready var player: Player = %Player
@onready var camera: Camera2D = %Camera
@onready var life_display: IconStatus = %LifeDisplay

func _ready() -> void:
	update_camera()
	camera.position = camera_target
	randomize()

func _process(delta: float) -> void:
	update_camera()
	camera.position = camera.position.move_toward(camera_target, 320*delta)
	
	life_display.value = player.health
	life_display.max_value = player.base_health

func update_camera() -> void:
	var cam := camera.position
	var pla := player.position
	
	if pla.x >= cam.x + 90:
		coords.x += 1
	elif pla.x <= cam.x - 90:
		coords.x -= 1
	
	if pla.y >= cam.y + 90:
		coords.y += 1
	elif pla.y <= cam.y - 90:
		coords.y -= 1
	
	camera_target = coords*screen_size_tiles*tile_size
	#prints(coords, %Camera.position)
