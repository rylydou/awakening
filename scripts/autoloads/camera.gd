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
	#position = position.lerp(target, 1 - exp(-5*delta))
	
	if not is_instance_valid(Game.player): return
	
	RenderingServer.global_shader_parameter_set('PLAYER_UV', (Game.player.position - position)/Vector2(320, 180) + Vector2(0.5, 0.5))

func _physics_process(delta: float) -> void:
	target_player()
	
	if room_coords != last_room_corrds:
		last_room_corrds = room_coords
		room_entered.emit(room_coords)

func center_camera() -> void:
	position = target

func target_player() -> void:
	if is_instance_valid(Game.player):
		target_room_at(Game.player.position)

func target_room_at(world_pos: Vector2) -> void:
	var ref := target
	
	room_coords = floor(world_pos/Vector2(Consts.ROOM_SIZE_PX))
	target = room_coords*Consts.ROOM_SIZE_PX+Consts.ROOM_SIZE_PX/2
