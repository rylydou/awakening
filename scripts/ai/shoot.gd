class_name Shoot extends Step

var proj_ref: Node2D

func _ready() -> void:
	proj_ref = get_child(0)
	remove_child(proj_ref)

func start() -> bool:
	var proj := proj_ref.duplicate() as Projectile
	proj.position = actor.position
	proj.direction = actor.direction
	actor.get_parent().add_child(proj)
	return true
