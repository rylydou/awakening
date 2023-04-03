extends Node
const LOOT_SCENE := preload('res://scenes/loot.tscn')

@export var drop_chance := Vector2i(1, 1)
@export var drops: Array[Loot.Type] = []

func trigger() -> void:
	if drops.size() == 0:
		prints('No drops ignoring...', owner.name)
		return
	if RNG.drop.randi_range(0, drop_chance.y) > drop_chance.x: return 
	
	var loot := LOOT_SCENE.instantiate() as Loot
	loot.type = drops.pick_random()
	loot.position = owner.global_position
	get_tree().current_scene.add_child.call_deferred(loot)
