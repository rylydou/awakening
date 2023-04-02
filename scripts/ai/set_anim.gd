class_name SetAnim extends Step

@export var animation_name := &''
@export var animation_type := Animator.AnimationType.Single

func start() -> bool:
	actor.animator.play_anim(animation_name, animation_type)
	return true
