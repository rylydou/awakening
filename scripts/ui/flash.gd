extends ColorRect

func _ready() -> void:
	modulate.a = 0.0

var tween: Tween
func flash() -> void:
	if is_instance_valid(tween):
		tween.kill()
	
	tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_SINE)
	#tween.tween_property(self, 'modulate:a', 1.0, 0.05).from(0.0)
	tween.tween_property(self, 'modulate:a', 0.0, 1.0).from(1.0)
	
