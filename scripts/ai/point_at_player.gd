class_name PointAtPlayer extends Step

enum AngleRestrictions {
	AnyAngle360,
	CardinalOnly,
	CardinalAndDiagonal,
}

@export var angle_restrictions: AngleRestrictions

func start() -> bool:
	var direction := actor.global_position.direction_to(Game.player.global_position)
	
	match angle_restrictions:
		AngleRestrictions.CardinalOnly:
			if abs(direction.x) >= abs(direction.y):
				direction.x = sign(direction.x)
				direction.y = 0
			else:
				direction.x = 0
				direction.y = sign(direction.y)
		
		AngleRestrictions.CardinalAndDiagonal:
			const THRESHOLD := .5 # =sin( 30deg )
			
			if abs(direction.x) < THRESHOLD:
				direction.x = 0
			else:
				direction.x = sign(direction.x)
			
			if abs(direction.y) < THRESHOLD:
				direction.y = 0
			else:
				direction.y = sign(direction.y)
			
			direction = direction.normalized()
	
	actor.direction = direction
	return true
