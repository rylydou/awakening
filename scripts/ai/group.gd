class_name Group extends Step

var current_step: Step
var next_index := 0

func start() -> bool:
	if get_child_count() == 0: return true
	
	next_index = 0
	return next()

func tick(delta: float) -> bool:
	if get_child_count() == 0: return true
	
	var is_finished := current_step.tick(delta)
	if not is_finished: return false
	
	return next()

func next() -> bool:
	while true:
		if next_index >= get_child_count(): return true
		
		var step = get_child(next_index)
		next_index += 1
		
		if step.has_method('trigger'):
			step.call('trigger')
			continue
		
		current_step = step
		
		var is_finished := current_step.start()
		if not is_finished: return false
	
	return false #should never reach

func init() -> void:
	for child in get_children():
		if not child is Step: continue
		
		child.actor = actor
		if child is Group:
			child.init()
