class_name ItemInfo extends Resource

@export var id := &''
@export var name := ''
@export var item_icon_coords := Vector2i(1, 0)

@export var item_fx_region := Rect2i(0, 0, 1, 1)
#@export var item_fx_frame_count := 1

@export var animation_name: StringName
@export var animation_type: Animator.AnimationType = Animator.AnimationType.FourDirectional

@export_range(0, 16, 1, 'or_greater') var hitbox_damage := 0



@export var item_specifics_script: Script
