extends Node2D

@onready var target: Node2D = %Target
@onready var raycast: RayCast2D = %Raycast

@export var max_charge := 120
@export var charge_inc := 2

var charge := 0

func _physics_process(delta: float) -> void:
	$SpriteStack.look_at(Game.player.position)
	target.position = to_local(Game.player.position)
	raycast.target_position = target.position
	raycast.force_raycast_update()
	
	if raycast.is_colliding():
		if charge > 0:
			charge -= 1
	else:
		charge += charge_inc
	
	if charge > max_charge:
		charge = 0
		SoundBank.play_ui('shoot.plasma')
