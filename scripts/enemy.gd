extends Actor

var stun_timer := 0

var was_stunned := false
func _physics_process(delta: float) -> void:
	var is_stunned := stun_timer > 0
	if is_stunned != was_stunned:
		if not is_stunned:
			animator.play()
			%Flip.modulate = Color.WHITE
	
	was_stunned = is_stunned
	
	if is_stunned and health > 0:
		stun_timer -= 1
		animator.pause()
		%Flip.modulate = Color.GRAY
		%Flip.position.x = wrapi(stun_timer, -1, 1)
		return
	
	state_machine.run(delta)

func apply_stun(amount: int) -> bool:
	if amount > stun_timer:
		stun_timer = amount
	return true

func take_damage(damage: int, source: Node) -> bool:
	stun_timer = 0
	return super.take_damage(damage, source)
