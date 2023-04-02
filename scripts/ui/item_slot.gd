extends NinePatchRect

@export var slot_index := -1

@onready var item_sprite: NinePatchRect = %ItemSprite

func _enter_tree() -> void:
	Inventory.slot_changed.connect(_on_slot_changed)

func _on_slot_changed(index: int, item_id: StringName) -> void:
	if index != self.slot_index: return
	
	if item_id.is_empty():
		item_sprite.region_rect.position = Vector2.ZERO
		return
	
	var item_info := ItemDB.get_item(item_id)
	item_sprite.region_rect.position = item_info.item_icon_coords*16.
