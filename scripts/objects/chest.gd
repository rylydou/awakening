extends StaticBody2D

@export var flag_name := &''
@export var item: Item

@onready var is_open := Flags.has(flag_name)

func _ready() -> void:
	update()

func update() -> void:
	if is_open:
		$Sprite.frame = 0

func interact() -> bool:
	if is_open:
		Dialog.say(['this chest has been already been opened.'])
		return true
	
	if Game.player.direction != Vector2.UP:
		Dialog.say(["i can't open this from here."])
		return true
	
	is_open = true
	Flags.raise(flag_name)
	update()
	Inventory.give_item(item.id)
	
	Dialog.say(['You found a %s!' % item.name])
	
	return true
