class_name Hurtbox extends Node

signal damaged(damage: int, source: Node)

func take_damage(damage: int, source: Node) -> bool:
	damaged.emit(damage, source)
	return true
