class_name DFU extends RefCounted

enum StatusCode {
	Ok,
	Ok_Created,
	Ok_Upgraded,
	Error,
	Error_OutOfDate,
}

const VERSION_KEY := '__version__'
const CURRENT_VERSION := 1
static func fix(ds: DataStore) -> StatusCode:
	var data_version := ds.fetch_int(VERSION_KEY, 0)
	
	if data_version > CURRENT_VERSION: return StatusCode.Error_OutOfDate
	
	# TODO: Upgrade data
	if data_version != CURRENT_VERSION:
		for version in range(data_version, CURRENT_VERSION):
			print('TODO: upgrade from data from version %s to %s' % [version, version + 1])
	
	ds.store(VERSION_KEY, CURRENT_VERSION)
	
	if data_version == 0: return StatusCode.Ok_Created
	if data_version < CURRENT_VERSION: return StatusCode.Ok_Upgraded
	return StatusCode.Ok
