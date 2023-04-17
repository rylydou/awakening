extends Camera2D

signal room_entered(room_coords: Vector2i)

@export var camera_speed := 24.

var target := Vector2.ZERO
var room_coords := Vector2i.ZERO
var last_room_corrds := Vector2i(-42069, -42069)

func _enter_tree() -> void:
	Game.boss_defeated.connect(func(boss: Node): %BossFlash.flash())
	Game.player_dying.connect(func(): %DeathFlash.flash())

func _process(delta: float) -> void:
	position = position.move_toward(target, camera_speed*16*delta)
	if not is_instance_valid(Game.player): return
	
	RenderingServer.global_shader_parameter_set('PLAYER_UV', (Game.player.position - position)/Vector2(320, 180) + Vector2(0.5, 0.5))

func _physics_process(delta: float) -> void:
	target_room()
	if room_coords != last_room_corrds:
		last_room_corrds = room_coords
		room_entered.emit(room_coords)

func center_camera() -> void:
	position = target

func target_room() -> void:
	if not is_instance_valid(Game.player): return
	
	var player := Game.player.position
	var ref := target
	
	var half_bounds := Consts.ROOM_SIZE_PX/2 + Vector2i.ONE*2
	
	if player.x >= ref.x + half_bounds.x:
		room_coords.x += 1
	elif player.x <= ref.x - half_bounds.x:
		room_coords.x -= 1
	
	if player.y >= ref.y + half_bounds.y:
		room_coords.y += 1
	elif player.y <= ref.y - half_bounds.y:
		room_coords.y -= 1
	
	target = room_coords*Consts.ROOM_SIZE_PX+Consts.ROOM_SIZE_PX/2
	#position = target
