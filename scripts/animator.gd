class_name Animator extends AnimationPlayer

enum AnimationType {
	Single,
	FourDirectional,
	EightDirectional,
	FourDirectional_DoubleFlip,
	EightDirectional_DoubleFlip,
}

@export var flip_node: Node2D

func play_anim(animation_name: StringName, animation_type: AnimationType) -> bool:
	var direction: Vector2 = owner.direction
	match animation_type:
		AnimationType.FourDirectional:
			
			if direction.y != 0:
				if direction.y > 0:
					animation_name += '_south'
				else:
					animation_name += '_north'
			else:
				animation_name += '_east'
			
			flip_node.scale.x = 1 if owner.direction.x >= 0 else -1
		
		AnimationType.EightDirectional:
			if abs(direction.y) >= 0.5:
				if direction.y >= 0:
					animation_name += '_south'
				else:
					animation_name += '_north'
			if abs(direction.x) >= 0.5:
				animation_name += '_east'
			
			flip_node.scale.x = 1 if direction.x >= 0 else -1
		
		AnimationType.FourDirectional_DoubleFlip:
			if abs(direction.y) >= abs(direction.x):
				animation_name += '_south'
			else:
				animation_name += '_east'
			
			flip_node.scale.y = 1 if direction.y >= 0 else -1
			flip_node.scale.x = 1 if direction.x >= 0 else -1
		
		AnimationType.EightDirectional_DoubleFlip:
			if abs(direction.y) >= 0.5:
				animation_name += '_south'
			if abs(direction.x) >= 0.5:
				animation_name += '_east'
			
			flip_node.scale.y = 1 if direction.y >= 0 else -1
			flip_node.scale.x = 1 if direction.x >= 0 else -1
	
	if not has_animation(animation_name):
		printerr('animation not found: ', animation_name)
		return false
	
	current_animation = animation_name
	return true
