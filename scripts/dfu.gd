class_name DFU extends RefCounted

enum StatusCode {
	Ok,
	Ok_Created,
	Ok_Upgraded,
	Error,
	Error_OutOfDate,
}

const VERSION_KEY := '__VERSION__'
const CURRENT_VERSION := 1
static func fix(ds: DataStore) -> StatusCode:
	var data_version := ds.fetch(VERSION_KEY, 0) as int
	
	if data_version > CURRENT_VERSION: return StatusCode.Error_OutOfDate
	
	
	if data_version == 0:
		create(ds)
	# TODO: Upgrade data
	elif data_version != CURRENT_VERSION:
		for version in range(data_version, CURRENT_VERSION):
			print('TODO: Upgrade from data from version %s to %s' % [version, version + 1])
	
	ds.store(VERSION_KEY, CURRENT_VERSION)
	
	if data_version == 0: return StatusCode.Ok_Created
	if data_version < CURRENT_VERSION: return StatusCode.Ok_Upgraded
	return StatusCode.Ok

static func create(ds: DataStore) -> void:
	ds.clear()
	#var inv := Inventory.EMPTY_INVENTORY.duplicate()
	#inv[0] = 'sword'
	#ds.store('inventory.items', inv)
