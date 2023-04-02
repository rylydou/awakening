class_name PlayAnim extends Step

@export var animation_name := &''
@export var animation_type := Animator.AnimationType.Single

var timer: float

func start() -> bool:
	var played_animation := actor.animator.play_anim(animation_name, animation_type)
	if not played_animation:
		actor.play_sound('error')
		return true
	
	timer = actor.animator.current_animation_length
	return false

func tick(delta: float) -> bool:
	timer -= delta
	return timer <= 0
