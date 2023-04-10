class_name Item extends Resource

@export var id := &''
@export var name := ''
@export var item_icon_coords := Vector2i(1, 0)

@export_category('')

@export var magic_cost := 0
@export var hitbox_damage := 0
@export var item_specifics_script: Script

@export_category('')

@export var item_fx_region := Rect2i(0, 0, 1, 1)
@export var sound_effect_name := &''

@export var animation_name: StringName
@export var animation_type: Animator.AnimationType = Animator.AnimationType.FourDirectional
