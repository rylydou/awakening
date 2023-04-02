extends ForeverLoop

func _ready() -> void:
	actor = owner
	init()

func enter(old_state: Node) -> void:
	start()

func run(delta: float) -> void:
	tick(delta)
