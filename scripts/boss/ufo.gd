extends CharacterBody2D

@export var speed := 4.0

var target: Vector2
var bomb_ticker := 0

var age := 0.0

func _ready() -> void:
	retarget()

func _physics_process(delta: float) -> void:
	age += delta
	
	const AMP := 32
	$BodySprite.position.y = sin(age*PI*2)/2*AMP-AMP/2
	
	#bomb_ticker += 1
	#if bomb_ticker > 120:
	#	bomb_ticker = 0
	#	drop_bomb()
	
	position = position.move_toward(target, speed*16*delta)
	if position.is_equal_approx(target):
		retarget()
		drop_bomb()
	

func retarget() -> void:
	target.x = RNG.ai.randf_range(0, Consts.ROOM_SIZE_PX.x)
	target.y = RNG.ai.randf_range(0, Consts.ROOM_SIZE_PX.y)

func drop_bomb() -> void:
	var node := preload('res://scenes/bomb.tscn').instantiate() as Node2D
	node.add_to_group('despawn')
	get_parent().add_child(node)
	var t := node.create_tween()
	t.set_ease(Tween.EASE_IN)
	t.set_trans(Tween.TRANS_QUAD)
	t.tween_property(node, 'position', position, 0.5).from(position + $BodySprite.position)
