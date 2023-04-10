class_name Enemy extends Actor

@export var spawn_block_distance := 0.
@export var marker: Marker2D

var stun_timer := 0

func _ready() -> void:
	if spawn_block_distance > 0 and Game.player.position.distance_squared_to(global_position) <= (spawn_block_distance*16)*(spawn_block_distance*16):
		queue_free()
		return
	super._ready()
	inv_timer = 10

var was_stunned := false
func _physics_process(delta: float) -> void:
	var is_stunned := stun_timer > 0
	if is_stunned != was_stunned:
		if not is_stunned:
			animator.playback_active = true
			%Flip.position.x = 0
			%Flip.modulate = Color.WHITE
	
	was_stunned = is_stunned
	
	if is_stunned and health > 0:
		stun_timer -= 1
		animator.playback_active = false
		%Flip.modulate = Color.GRAY
		%Flip.position.x = wrapi(stun_timer/2, -1, 1)
		return
	
	super._physics_process(delta)

func apply_stun(amount: int) -> bool:
	if amount > stun_timer:
		stun_timer = amount
	return true

func take_damage(damage: int, source: Node) -> bool:
	stun_timer = 0
	return super.take_damage(damage, source)
