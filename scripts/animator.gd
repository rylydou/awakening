class_name Animator extends AnimationPlayer

enum AnimationType {
	Single,
	FourDirectional,
	EightDirectional,
}

func play_anim(animation_name: StringName, animation_type: AnimationType) -> bool:
	match animation_type:
		AnimationType.FourDirectional:
			var direction: Vector2 = owner.direction
			
			if direction.y != 0:
				if direction.y > 0:
					animation_name += '_south'
				else:
					animation_name += '_north'
			else:
				animation_name += '_east'
			%Flip.scale.x = 1 if owner.direction.x >= 0 else -1
		AnimationType.EightDirectional:
			var direction: Vector2 = owner.direction
			
			if direction.y != 0:
				if direction.y > 0:
					animation_name += '_south'
				else:
					animation_name += '_north'
					
				if direction.x != 0:
					animation_name += 'east'
			else:
				animation_name += '_east'
			
			%Flip.scale.x = 1 if owner.direction.x >= 0 else -1
	
	if not has_animation(animation_name):
		printerr('animation not found: ', animation_name)
		return false
	
	current_animation = animation_name
	return true
