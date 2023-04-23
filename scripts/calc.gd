class_name Calc extends Object

static func angle_difference(from: float, to: float) -> float:
	var diff := fmod(to - from, TAU)
	return fmod(2.0 * diff, TAU) - diff

static func rotate_toward(from: float, to: float, delta: float) -> float:
	var diff := angle_difference(from, to)
	return from + minf(absf(diff), delta) * signf(diff)
