extends Node

const ITEM_DIR = 'res://resources/items/'

var _item_database: Dictionary = {}

var item_count := -1

# for type safe dictionary access
func get_item(item_id: StringName) -> ItemInfo:
	return _item_database[item_id]

func get_item_by_index(index: int) -> ItemInfo:
	return _item_database.values()[index]

func get_item_ids() -> Array[StringName]:
	return _item_database.keys()

func get_items() -> Array[ItemInfo]:
	return _item_database.values()

func _ready() -> void:
	assert(DirAccess.dir_exists_absolute(ITEM_DIR))
	for file in DirAccess.get_files_at(ITEM_DIR):
		if not file.ends_with('.tres') and not file.ends_with('.tres.remap'): continue
		file = file.trim_suffix('.remap')
		
		var item_path := ITEM_DIR + file
		var item_data = load(item_path) as ItemInfo
		assert(item_data, 'item def could not be loaded')
		
		_item_database[item_data.id] = item_data
	
	item_count = _item_database.size()
