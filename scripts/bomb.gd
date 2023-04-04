extends Node2D
@onready var explosion_node := %Explosion

@export var fuse_timer := 60

func _ready() -> void:
	explosion_node.hide()

func _physics_process(delta: float) -> void:
	if fuse_timer < 0: return
	
	fuse_timer -= 1
	if fuse_timer < 0:
		explode()

func explode() -> void:
	explosion_node.show()
	explosion_node.reparent(get_parent())
	explosion_node.propagate_call('play', ['explode'])
	#get_parent().add_child(explosion_node.duplicate())
	queue_free.call_deferred()
