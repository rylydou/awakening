extends StaticBody2D

signal damaged(damage: int, source: Node)
signal killed()

@onready var sprite: Sprite2D = $Sprite

@export var inv_time := 60
var inv_timer := 0

func _physics_process(delta: float) -> void:
	if inv_timer > 0:
		inv_timer -= 1
	
	sprite.material.set_shader_parameter('invert_intensity', (inv_timer/2)%2)
	#sprite.material.set_shader_parameter('flash_color', Color(1., 1., 1., (inv_timer/2)%2))

func take_damage(damage: int, source: Node) -> bool:
	if inv_timer > 0: return false
	
	inv_timer = inv_time
	
	damaged.emit(damage, source)
	killed.emit()
	
	return true
