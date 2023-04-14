class_name Warn extends Step

@export var time := 30
@export var amplitude := 1
@export var delay := 2

@export var node: Sprite2D

var timer := 0

func start() -> bool:
	timer = 0
	return false

func tick(delta: float) -> bool:
	if timer > time: return true
	
	timer += 1
	node.offset.x = wrapi(timer/delay, -amplitude, amplitude)
	
	if timer > time: return true
	return false
