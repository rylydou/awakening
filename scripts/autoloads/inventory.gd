extends Node

enum StatusCode {
	Ok,
	Error,
	Error_InvalidIndex,
	Error_NoSpace,
	Error_Empty,
}

var EMPTY_INVENTORY: Array = [
	&'', &'', &'', # itembar
	&'', &'', &'', &'', # inventory row 1
	&'', &'', &'', &'', # inventory row 2
]

# inventory
var items: Array = []

signal inventory_changed()
signal slot_changed(index: int, item: StringName)
signal gained_item(id: StringName, index: int)
signal lost_item(id: StringName, index: int)
signal swapped_items(from_index: int, to_index: int)

func _ready() -> void:
	Game.store.connect(store)
	Game.fetch.connect(fetch)

func store(ds: DataStore) -> void:
	ds.push_prefix('inventory')
	ds.store_flags('items', items)
	ds.pop_prefix()

func fetch(ds: DataStore) -> void:
	ds.push_prefix('inventory')
	items = ds.fetch_flags('items', EMPTY_INVENTORY)
	ds.pop_prefix()
	inventory_changed.emit()
	for index in items.size():
		slot_changed.emit(index, items[index])

func give_all_items() -> void:
	for item_id in ItemDB.get_item_names():
		give_item(item_id)

func set_slot(index: int, item_id: StringName) -> void:
	items[index] = item_id
	inventory_changed.emit()
	slot_changed.emit(index, item_id)

func give_item(item_id: StringName) -> StatusCode:
	var empty_slot_index := items.find(&'')
	if empty_slot_index < 0:
		print_debug('Could not give item to player. Ran out of space in inventory.')
		return StatusCode.Error_NoSpace
	
	set_slot(empty_slot_index, item_id)
	gained_item.emit(item_id, empty_slot_index)
	
	return StatusCode.Ok

func remove_item_at(index: int) -> StatusCode:
	if items[index] == &'':
		print_debug('Cannot remove item at %s. Slot is already empty' % index)
		return StatusCode.Error_Empty
	
	var item_id = items[index]
	set_slot(index, &'')
	lost_item.emit(item_id, index)
	
	return StatusCode.Ok

func swap_items(index_a: int, index_b: int) -> StatusCode:
	var item_a := items[index_a] as StringName
	var item_b := items[index_b] as StringName
	set_slot(index_a, item_b)
	set_slot(index_b, item_a)
	swapped_items.emit(index_a, index_b)
	
	return StatusCode.Ok
