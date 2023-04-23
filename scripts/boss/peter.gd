extends Node2D

@onready var head_node: Node2D = %Head
@onready var butt_node: Node2D = %Butt
@onready var projectile_node: Node2D = %Projectile
@onready var head_sprite: Sprite2D = %HeadSprite

@export var base_health := 3
@onready var health := base_health

@export var prediction_over_distance: Curve
@export var prediction_distance := 10.0

@export var shoot_time_over_health: Curve
@onready var shoot_time := shoot_time_over_health.sample_baked(0)
var shoot_timer := 0

@export var stun_time_over_hits: Curve
@export var stun_hits := 5
var times_hit := 0

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
		head_sprite.frame = 0
		return
	
	shoot_timer -= 1
	if shoot_timer <= 0:
		shoot_timer = shoot_time
		if distance < 2.5:
			too_close_counter += 1
			if too_close_counter >= 4:
				too_close_counter = 0
				spawn_ghost(global_position)
				teleport()
		else:
			if too_close_counter > 0:
				too_close_counter -= 1
			SoundBank.play('shoot.peter', global_position)
			shoot()
		
		from_angle = target_angle
		const PLAYER_SPEED := 16*4
		var target := Game.player.position
		var prediction_amount := prediction_over_distance.sample_baked(distance/prediction_distance)
		target += Game.player.input_move*PLAYER_SPEED*min(shoot_time/60., 45)*prediction_amount
		target_angle = global_position.angle_to_point(target)
	
	angle = lerp_angle(from_angle, target_angle, 1 - float(shoot_timer)/shoot_time)
	
	var vector: Vector2
	vector = Vector2.from_angle(angle)
	
	if abs(vector.x) > 0.5 and abs(vector.y) > 0.5:
		head_sprite.frame = 2
	elif abs(vector.x) > abs(vector.y):
		head_sprite.frame = 3
	else:
		head_sprite.frame = 1
	head_sprite.flip_h = vector.x < 0
	head_sprite.flip_v = vector.y < 0
	
	vector *= 18.0
	head_node.position = vector
	butt_node.position = -vector

func shoot() -> void:
	var node := projectile_node.duplicate()
	node.add_to_group('despawn')
	node.direction = Vector2.from_angle(angle)
	node.position = position + head_node.position + node.direction*8.0
	get_parent().add_child(node)

func spawn_ghost(pos: Vector2) -> void:
	if get_tree().get_nodes_in_group('from_peter').size() >= 4: return
	
	var node := preload('res://scenes/enemies/kyle.tscn').instantiate()
	node.add_to_group('despawn')
	node.add_to_group('from_peter')
	node.position = pos
	node.stun_timer = 30
	get_parent().add_child(node)

var tele_tween: Tween
func teleport() -> void:
	var from := global_position
	for i in 16:
		position.x = RNG.ai.randf_range(16, Consts.ROOM_SIZE_PX.x - 16)
		position.y = RNG.ai.randf_range(16, Consts.ROOM_SIZE_PX.y - 16)
		
		if global_position.distance_squared_to(from) < 64*64: continue
		if global_position.distance_squared_to(Game.player.position) > 64*64: continue
		
		break
	
	if is_instance_valid(tele_tween):
		tele_tween.kill()
	tele_tween = create_tween()
	%GhostSprite.show()
	#%GhostSprite.position = from
	$AnimationPlayer.pause()
	tele_tween.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_BACK)
	tele_tween.tween_property(%GhostSprite, 'position', global_position, max(stun_timer, 15)/60.).from(from)
	tele_tween.tween_callback(%GhostSprite.hide)
	tele_tween.tween_callback($AnimationPlayer.play)

func die() -> void:
	SoundBank.play('death.boss.peter', global_position)
	
	Game.boss_defeated.emit(self)
	queue_free.call_deferred()

func _on_head_damaged(damage, source) -> void:
	times_hit += 1
	stun_timer = stun_time_over_hits.sample_baked(float(times_hit)/stun_hits)*60
	
	spawn_ghost.call_deferred(global_position)
	
	SoundBank.play('teleport.boss', global_position)
	teleport()

func _on_butt_killed() -> void:
	if health <= 0: return
	SoundBank.play('hurt.boss.peter', global_position)
	
	health -= 1
	if health <= 0:
		die()
		return
	
	times_hit = 0
	stun_timer = 0
	shoot_time = shoot_time_over_health.sample_baked(1 - float(health)/base_health)
	teleport()
