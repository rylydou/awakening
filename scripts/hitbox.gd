class_name Hitbox extends Area2D

signal attacked(node: Node2D)

@export_range(0, 100, 1, 'or_greater', 'suffix:hp') var damage := 1
@export var auto_attack := false
@export var remember_hits := false
@export var stun_amount := 0

var things_hit: Array[Node2D] = []
func forget_hits():
	things_hit.clear()

func _ready() -> void:
	body_entered.connect(on_body_entered)

func on_body_entered(body: Node2D) -> void:
	if not auto_attack: return
	attack_node(body)

func attack_overlap(damage: int = -1) -> int:
	var count = 0
	for body in get_overlapping_bodies():
		if attack_node(body, damage):
			count += 1
	return count

func attack_node(node: Node2D, damage: int = -1) -> bool:
	if not node.has_method('take_damage'): return false
	if things_hit.has(node): return false
	if node == owner: return false
	if owner is Actor and owner.health <= 0: return false
	
	if damage < 0: damage = self.damage
	
	var did_attack := node.call('take_damage', damage, owner) as bool
	if did_attack:
		if stun_amount > 0 and node.has_method('apply_stun'):
			var stunned := node.call('apply_stun', stun_amount) as bool
		
		attacked.emit(node)
		if remember_hits:
			things_hit.append(node)
		return true
	return false
