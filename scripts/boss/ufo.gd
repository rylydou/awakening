extends CharacterBody2D

@export var speed := 8.0

var target: Vector2
var bomb_ticker := 0

var age := 0.0
var target_reached_ticker := 0

func _ready() -> void:
	retarget()

func _physics_process(delta: float) -> void:
	age += delta
	
	const AMP := 8
	$BodySprite.position.y = sin(age*PI*2)/2*AMP-AMP/2 - 32
	#$BodySprite.position.y = 0
	
	#bomb_ticker += 1
	#if bomb_ticker > 120:
	#	bomb_ticker = 0
	#	drop_bomb()
	
	if position.is_equal_approx(target):
		if target_reached_ticker == 0:
			drop_bomb()
		
		target_reached_ticker += 1
		
		if target_reached_ticker > 20:
			target_reached_ticker = 0
			retarget()
	else:
		position = position.move_toward(target, speed*16*delta)

func retarget() -> void:
	target.x = RNG.ai.randf_range(16, Consts.ROOM_SIZE_PX.x - 32)
	target.y = RNG.ai.randf_range(64, Consts.ROOM_SIZE_PX.y - 32)

const BOMB_SCENE := preload('res://scenes/bomb.tscn')
const TANK_SCENE := preload('res://scenes/enemies/charlie.tscn')
func drop_bomb() -> void:
	var scene := BOMB_SCENE
	if RNG.misc.randi() % 5 == 0:
		scene = TANK_SCENE
	
	var node := scene.instantiate() as Node2D
	node.add_to_group('despawn')
	get_parent().add_child(node)
	
	var t := node.create_tween()
	t.set_ease(Tween.EASE_IN)
	t.set_trans(Tween.TRANS_QUAD)
	t.tween_property(node, 'position', position, 0.5).from(position + $BodySprite.position)
