extends Projectile

@onready var hitbox: Hitbox = %Hitbox
func die() -> void:
	if hitbox.things_hit.size() == 0:
		drop_loot(Loot.Type.Arrow_Dud)
	elif hitbox.things_hit.size() >= 3:
		drop_loot(Loot.Type.Money_1)
		SoundBank.play('power_hit', global_position)
	super.die()

func drop_loot(loot: Loot.Type) -> void:
	const LOOT_SCENE := preload('res://scenes/loot.tscn')
	var loot_node := LOOT_SCENE.instantiate() as Loot
	loot_node.type = loot
	loot_node.position = global_position
	get_tree().current_scene.add_child.call_deferred(loot_node)
