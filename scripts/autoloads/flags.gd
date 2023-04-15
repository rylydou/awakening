extends Node

var flags := {}

func _enter_tree() -> void:
	Game.fetch.connect(_fetch)
	Game.store.connect(_store)

func _fetch(ds: DataStore) -> void:
	flags = ds.fetch_flags('flags')

func _store(ds: DataStore) -> void:
	ds.store_flags('flags', flags)

func raise(flag_name: StringName) -> void:
	if flag_name.is_empty(): return
	
	flags[flag_name] = true

func lower(flag_name: StringName) -> void:
	if flag_name.is_empty(): return
	if not flags.has(flag_name): return
	flags.erase(flag_name)

func has(flag_name: StringName) -> bool:
	# if no flag is defined then return true
	if flag_name.is_empty(): return true
	
	# mirror items for QoL
	if flag_name.begins_with(&'item_'):
		return Inventory.items.has(flag_name.trim_prefix(&'item_'))
	
	return flags.has(flag_name)
