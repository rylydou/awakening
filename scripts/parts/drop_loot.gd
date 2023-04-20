extends Node
const LOOT_SCENE := preload('res://scenes/loot.tscn')

const POOL1: Array[Loot.Type] = [
	Loot.Type.Money_1,
	Loot.Type.Magic_SM,
]

const POOL2: Array[Loot.Type] = [
	Loot.Type.Money_5,
	Loot.Type.Life_SM,
	# Magic MD?
]

const POOL3: Array[Loot.Type] = [
	Loot.Type.Money_10,
	Loot.Type.Life_LG,
	Loot.Type.Magic_LG,
]

@export var drop_chance := Vector2i(1, 1)
@export var can_drop_money := true
@export var pool1 := 3 
@export var pool2 := 2 
@export var pool3 := 1 

func trigger() -> void:
	if drop_chance.x <= 0: return
	if RNG.drop.randi_range(0, drop_chance.y) > drop_chance.x: return 
	
	var sum := pool1 + pool2 + pool3
	var num := RNG.drop.randi_range(0, sum)
	var pool := POOL1
	if pool3 > 0 and num <= pool3:
		pool = POOL3
	elif pool2 > 0 and num <= pool3 + pool2:
		pool = POOL2
	
	var type = pool[RNG.drop.randi_range(0 if can_drop_money else 1, pool.size() - 1)]
	
	var loot := LOOT_SCENE.instantiate() as Loot
	loot.position = owner.global_position
	loot.type = type
	get_tree().current_scene.add_child.call_deferred(loot)
