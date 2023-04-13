extends Node

enum StatusCode {
	Ok,
	Error,
	Error_InvalidIndex,
	Error_NoSpace,
	Error_Empty,
}

const EMPTY_INVENTORY: Array = [
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

var magic: int
var max_magic: int

var money: int

func _ready() -> void:
	Game.store.connect(_store)
	Game.fetch.connect(_fetch)

func _store(ds: DataStore) -> void:
	ds.push_prefix('inventory')
	ds.store('items', items)
	
	ds.store('magic', magic)
	ds.store('max_magic', max_magic)
	
	ds.store('money', money)
	ds.pop_prefix()

func _fetch(ds: DataStore) -> void:
	ds.push_prefix('inventory')
	
	var fetched_items = ds.fetch('items')
	if fetched_items == null or fetched_items.size() == 0:
		print('generating inventory')
		items = EMPTY_INVENTORY.duplicate()
	else:
		items = fetched_items
	
	magic = ds.fetch('magic', 6*8)
	max_magic = ds.fetch('max_magic', 6*8)
	
	money = ds.fetch('money', 0)
	
	ds.pop_prefix()
	
	inventory_changed.emit()
	for index in items.size():
		slot_changed.emit(index, items[index])

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
