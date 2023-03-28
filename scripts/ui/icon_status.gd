class_name IconStatus extends Control

@export_range(0, 16, 1, 'or_greater') var value := 3*4
@export_range(0, 16, 1, 'or_greater') var max_value := 3*4
@export_range(0, 16, 1, 'or_greater') var pregen_icon_count := 20

@export_group('Setup')
@export var texture: Texture2D
@export var icon_size := Vector2(8, 8)
@export var start_coords := Vector2(0, 0)
@export_range(2, 16, 1, 'or_greater') var icon_count := 2
@export var sprite_size := Vector2(8, 8)

var _last_value := 0
var _last_max := 0

func _ready() -> void:
	for child in get_children():
		remove_child(child)
		child.queue_free()
	
	for _i in range(pregen_icon_count):
		var spr := NinePatchRect.new()
		spr.visible = false
		spr.texture = texture
		spr.custom_minimum_size = sprite_size
		add_child(spr)

func _process(_delta: float) -> void:
	if _last_value != value:
		_last_value = value
		for node in get_children():
			var spr := node as NinePatchRect
			var index := spr.get_index()
			var frame := 0
			# is full heart? then use the last frame
			if (index + 1)*(icon_count - 2) < value:
				frame = icon_count - 1
			# or else then fill the heart appropriately
			elif index == (value - 1)/(icon_count - 2) and value > 0:
				frame = (value - 1)%(icon_count - 2) + 1
			spr.region_rect = calc_rect(frame)
	
	if _last_max != max_value:
		_last_max = max_value
		# update the max hearts too
		for node in get_children():
			var spr := node as NinePatchRect
			var index := spr.get_index()
			spr.visible = index*(icon_count - 2) < max_value

func calc_rect(index: int) -> Rect2:
	var rect := Rect2(start_coords, sprite_size)
	rect.position.x += index*icon_size.x
	return rect
