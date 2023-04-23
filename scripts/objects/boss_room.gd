extends Area2D

@export var flag_name := &''
@export var door_node: Node
@export var boss_node: Node
@export var loot_node: Node

var my_door: Node
var my_boss: Node

func _ready() -> void:
	body_entered.connect(_body_entered)
	Game.boss_defeated.connect(_boss_defeated)

func _body_entered(player: Player) -> void:
	if not is_primed: return
	is_primed = false
	
	start_bossfight.call_deferred()

func start_bossfight() -> void:
	my_boss = Region.setup_node(boss_node)
	my_door = Region.setup_node(door_node)

var is_primed := false
func setup() -> void:
	var is_beaten := Flags.has(flag_name)
	
	if not is_beaten:
		is_primed = true
		return
	
	Region.setup_node(loot_node)

func _boss_defeated(boss: Node) -> void:
	if boss != my_boss:
		print_debug('Not my boss')
		return
	
	print_debug('Defeated my boss, reloading room')
	Flags.raise(flag_name)
	Camera.room_entered.emit(Camera.room_coords)
