extends Area2D

@export var flag_name := &''
@export var door_node: Node
@export var boss_node: Node
@export var loot_node: Node

var door: Node

func _ready() -> void:
	body_entered.connect(_body_entered)

func _body_entered(player: Player) -> void:
	if not is_primed: return
	is_primed = false
	
	Region.setup_node(boss_node)
	
	door = Region.setup_node(door_node)

var is_primed := false
func setup() -> void:
	var is_beaten := Flags.has(flag_name)
	
	if not is_beaten:
		is_primed = true
		return
	
	Region.setup_node(loot_node)
