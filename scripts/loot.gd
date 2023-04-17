class_name Loot extends Node2D

enum Type {
	Money_1,
	Money_5,
	Money_10,
	Money_50,
	
	Life_SM,
	Life_LG,
	
	Magic_SM,
	Magic_LG,
	Arrow_Dud,
}

var type: Type

@export var nopickup_time := 20
@export var sprite_bounce_curve: Curve
@export var sprite_bounce_time := 30

@onready var sprite: Sprite2D = %Sprite

func _ready() -> void:
	match type:
		Type.Money_1: sprite.frame = 0
		Type.Money_5: sprite.frame = 1
		Type.Money_10: sprite.frame = 2
		Type.Money_50: sprite.frame = 3
		
		Type.Life_SM: sprite.frame = 4
		Type.Life_LG: sprite.frame = 5
		
		Type.Magic_SM: sprite.frame = 8
		Type.Magic_LG: sprite.frame = 9
		Type.Arrow_Dud: sprite.frame = 6
		
		_: printerr('Unknown loot type:' + str(type))

var age := 0
func _physics_process(delta: float) -> void:
	age += 1
	sprite.offset.y = -sprite_bounce_curve.sample_baked(float(age)/sprite_bounce_time)

func _on_pickup_area_body_entered(body: Node2D) -> void:
	pickup()

func take_damage(damage: int, source: Node) -> bool:
	pickup()
	return false

var picked_up := false
func pickup() -> void:
	if age < nopickup_time: return
	
	if picked_up: return
	picked_up = true
	
	SoundBank.play('money', global_position)
	
	match type:
		Type.Money_1: Inventory.money += 1
		Type.Money_5: Inventory.money += 5
		Type.Money_10: Inventory.money += 10
		Type.Money_50: Inventory.money += 50
		
		Type.Life_SM: Game.player.health += 1 *4 # one heart
		Type.Life_LG: Game.player.health += 3 *4 # three hearts
		
		Type.Magic_SM: Inventory.magic += 1 *6 # one pouch
		Type.Magic_LG: Inventory.magic += 3 *6 # three pouches
		Type.Arrow_Dud: Inventory.magic += 2 # one-third of a pouch
		
		_: printerr('Unknown loot type: ' + str(type))
	
	Inventory.money = min(Inventory.money, 5000)
	Inventory.magic = min(Inventory.magic, Inventory.max_magic)
	Game.player.health = min(Game.player.health, Game.player.base_health)
	
	queue_free()
