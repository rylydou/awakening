class_name Animator extends AnimationPlayer

func play_directional(anim_name: StringName) -> bool:
	var suffix := get_suffix()
	var full_anim_name := anim_name + '_' + suffix
	if not has_animation(full_anim_name): return false
	
	current_animation = full_anim_name
	%Flip.scale.x = 1 if owner.direction.x >= 0 else -1
	return true

func get_suffix() -> String:
	var direction: Vector2 = owner.direction
	if direction.y != 0:
		if direction.y > 0:
			return 'south'
		else:
			return 'north'
	return 'east'
