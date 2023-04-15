extends Node

@onready var player: Player = owner

@export var drown_time := 30
@export var damage := 2

var timer := 0

func enter(old_state: Node) -> void:
	timer = 0
	player.animator.play_anim('drown', Animator.AnimationType.Single)

func run(delta: float) -> void:
	if player.floor_detector_area.has_overlapping_bodies():
		player.state_machine.exit_state()
		return
	
	if timer > drown_time: return
	timer += 1
	if timer > drown_time:
		player.respawn()
		player.take_damage(damage, player)
