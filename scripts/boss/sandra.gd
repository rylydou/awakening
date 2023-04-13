extends CharacterBody2D

@export var speed_over_health: Curve
@export var turn_speed := 0.0
#@export var segment_offset_frames := 10

@export var segment_spacing := 12.0
@export var segment_count := 4
@export var segment_node: Node2D
var segments: Array[Node2D]

@export var butt_segment_node: Node2D

var history: Array[Vector2]

func _ready() -> void:
	segments.append(segment_node)
	for i in segment_count-1:
		var segment := segment_node.duplicate()
		add_child(segment)
		segments.append(segment)
	
	for i in segment_count:
		var segment := segments[i]
		segment.name = 'Seg%s' % i
		segment.position = global_position
		segment.position.x -= (i+1)*16
		segment.z_index = -(i+1)
	
	history.resize(1000)
	history.fill(global_position)

var rot := 0.0
var direction := Vector2.RIGHT
var age := 0.0
func _physics_process(delta: float) -> void:
	var health := float(segments.size())/segment_count
	
	age += delta
	
	turn_speed = sin(age*PI*2)*1.0
	rot += turn_speed*PI*2*delta
	var dir := Vector2.from_angle(rot)
	
	var move_speed := speed_over_health.sample_baked(1 - health)*16
	var motion := dir*move_speed
	var hit := move_and_collide(motion*delta)
	
	if hit:
		#rot = hit.get_normal().reflect(direction).angle()
		rot = global_position.angle_to_point(Game.player.position)
		direction = Vector2.from_angle(rot)
	
	
	var segment_frame_gap := (1./delta)/move_speed*segment_spacing
	
	for i in segments.size():
		var segment := segments[i]
		segment.position = history[(i + 1)*segment_frame_gap]
	butt_segment_node.global_position = history[(segments.size() + 1)*segment_frame_gap]
	
#	var segs := segments.duplicate()
#	segs.push_front(self)
#	segs.push_back(butt_segment_node)
#	for i in range(1, segs.size()):
#		var current := segs[i] as Node2D
#		var previous := segs[i - 1] as Node2D
#		if current.global_position.distance_squared_to(previous.global_position) >= 12*12:
#			current.global_position = current.global_position.move_toward(previous.global_position, move_speed*delta)
	
	direction = Vector2.from_angle(rot)
	$Animator.play_anim('pinch', Animator.AnimationType.EightDirectional_DoubleFlip)
	
	history.push_front(global_position)
	history.pop_back()

func take_damage(damage: int, source: Node) -> bool:
	if segments.size() == 0:
		queue_free()
		return true
	
	var segment := segments.pop_back() as Node2D
	remove_child(segment)
	segment.queue_free()
	
	return true
