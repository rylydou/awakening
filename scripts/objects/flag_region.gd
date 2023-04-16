extends Region

@export var flag_name: StringName 
@export var invert := false

func setup() -> void:
	if Flags.has(flag_name) == invert: return
	
	super.setup()
