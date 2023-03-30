extends Camera2D

signal room_entered(room_coords: Vector2i)

var target := Vector2.ZERO
var room_coords := Vector2i.ZERO
var last_room_corrds := Vector2i(-42069, -42069)

func _ready() -> void:
	target_room()
	center_camera()

func _process(delta: float) -> void:
	position = position.move_toward(target, 320*delta)

func _physics_process(delta: float) -> void:
	target_room()
	if room_coords != last_room_corrds:
		last_room_corrds = room_coords
		room_entered.emit(room_coords)

func center_camera() -> void:
	position = target

func target_room() -> void:
	if not is_instance_valid(Game.player): return
	
	var player := Game.player.global_position
	var ref := target
	
	var half_bounds := Consts.ROOM_SIZE_PX/2
	
	if player.x >= ref.x + half_bounds.x:
		room_coords.x += 1
	elif player.x <= ref.x - half_bounds.x:
		room_coords.x -= 1
	
	if player.y >= ref.y + half_bounds.y:
		room_coords.y += 1
	elif player.y <= ref.y - half_bounds.y:
		room_coords.y -= 1
	
	target = room_coords*Consts.ROOM_SIZE_PX+half_bounds
