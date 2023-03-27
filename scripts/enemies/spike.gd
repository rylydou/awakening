extends CharacterBody2D

func take_damage(damage: int, source: Node) -> bool:
	do_anim()
	return true

func do_anim() -> void:
	for i in 4:
		hide()
		await get_tree().create_timer(.2, false, true, false).timeout
		show()
