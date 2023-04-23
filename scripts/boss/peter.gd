extends Node2D

@onready var head_node: Node2D = %Head
@onready var butt_node: Node2D = %Butt
@onready var projectile_node: Node2D = %Projectile
@onready var head_sprite: Sprite2D = %HeadSprite

@export var prediction_over_distance: Curve
@export var prediction_distance := 10.0

@export var shoot_time := 30
var shoot_timer := 0

func _ready() -> void:
	remove_child(projectile_node)

var angle := 0.0
var from_angle := 0.0
var target_angle := 0.0
var stun_timer := 0
var too_close_counter := 0
func _physics_process(delta: float) -> void:
	var distance := global_position.distance_to(Game.player.position)/16
	
	if stun_timer > 0:
		stun_timer -= 1
		return
	
	shoot_timer -= 1
	if shoot_timer <= 0:
		shoot_timer = shoot_time
		if distance < 2.5:
			too_close_counter += 1
			if too_close_counter >= 5:
				too_close_counter = 0
				spawn_ghost(Vector2.ZERO)
				teleport()
		else:
			too_close_counter = 0
			shoot()
		
		from_angle = target_angle
		const PLAYER_SPEED := 16*4
		var target := Game.player.position
		var prediction_amount := prediction_over_distance.sample_baked(distance/prediction_distance)
		target += Game.player.input_move*PLAYER_SPEED*(shoot_time/60.)*prediction_amount
		target_angle = global_position.angle_to_point(target)
	
	angle = lerp_angle(from_angle, target_angle, 1 - float(shoot_timer)/shoot_time)
	
	var vector: Vector2
	vector = Vector2.from_angle(angle)
	
	if abs(vector.x) > 0.5 and abs(vector.y) > 0.5:
		head_sprite.frame = 1
	elif abs(vector.x) > abs(vector.y):
		head_sprite.frame = 2
	else:
		head_sprite.frame = 0
	head_sprite.flip_h = vector.x < 0
	head_sprite.flip_v = vector.y < 0
	
	vector *= 16.0
	head_node.position = vector
	butt_node.position = -vector

func shoot() -> void:
	var node := projectile_node.duplicate()
	node.add_to_group('despawn')
	node.direction = Vector2.from_angle(angle)
	node.position = position + head_node.position + node.direction*8.0
	get_parent().add_child(node)

func spawn_ghost(pos: Vector2) -> void:
	var node := preload('res://scenes/enemies/kyle.tscn').instantiate()
	node.add_to_group('despawn')
	node.position = position + pos
	get_parent().add_child(node)

func teleport() -> void:
	while true:
		position.x = RNG.ai.randf_range(16, Consts.ROOM_SIZE_PX.x - 16)
		position.y = RNG.ai.randf_range(16, Consts.ROOM_SIZE_PX.y - 16)
		if global_position.distance_squared_to(Game.player.position) > 48*48: return

func _on_head_damaged(damage, source) -> void:
	spawn_ghost(Vector2.ZERO)
	#spawn_ghost(Vector2(-8, -8))
	#spawn_ghost(Vector2(8, -8))
	#spawn_ghost(Vector2(0, 8))
	teleport()
	stun_timer = 120
