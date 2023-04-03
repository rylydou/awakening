class_name Loot extends Area2D

enum Type {
	Money_1,
	Money_5,
	Money_10,
	Money_50,
	
	Life,
	Magic,
	Arrow,
	ArrowBundle,
	Bomb,
	Fariy,
}

var type: Type

@onready var sprite: Sprite2D = %Sprite

func _ready() -> void:
	match type:
		Type.Money_1: sprite.frame = 0
		Type.Money_5: sprite.frame = 1
		Type.Money_10: sprite.frame = 2
		Type.Money_50: sprite.frame = 3
		
		Type.Life: sprite.frame = 4
		Type.Magic: sprite.frame = 8
			
		Type.Arrow: sprite.frame = 6
		Type.ArrowBundle: sprite.frame = 7
		Type.Bomb: sprite.frame = 10
		_: printerr('Unknown type:' + str(type))

var picked_up := false
func _on_body_entered(body: Player) -> void:
	if picked_up: return
	picked_up = true
	
	SoundBank.play('money', global_position)
	
	match type:
		Type.Money_1: Inventory.money += 1
		Type.Money_5: Inventory.money += 5
		Type.Money_10: Inventory.money += 10
		Type.Money_50: Inventory.money += 50
		
		Type.Life: Game.player.health += 4
		Type.Magic: print('TODO: Magic')
		
		Type.Arrow: Inventory.arrows += 1
		Type.ArrowBundle: Inventory.arrows += 3
		Type.Bomb: Inventory.bombs += 1
		
		_: printerr('Unknown type: ' + str(type))
	
	Inventory.money = min(Inventory.money, 5000)
	Inventory.arrows = min(Inventory.arrows, 10)
	Game.player.health = min(Game.player.health, Game.player.base_health)
	Inventory.bombs = min(Inventory.bombs, 10)
	
	queue_free()
