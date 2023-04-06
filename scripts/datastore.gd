class_name DataStore extends RefCounted

enum Format {
	TextFile,
	BytesFile,
}

var _data := {}
var _cache := {}

var path: String
var format: Format

var prefixes: PackedStringArray = []
var prefix_str := ''

func clear() -> void:
	_data.clear()

func push_prefix(prefix: StringName):
	prefixes.append(prefix + '.')
	_update_prefix_str()

func pop_prefix():
	prefixes.remove_at(prefixes.size() - 1)
	_update_prefix_str()

func _update_prefix_str():
	prefix_str = ''
	prefix_str = prefix_str.join(prefixes)

func has(key: StringName) -> bool:
	return _data.has(prefix_str + key)

func store(key: StringName, value: Variant) -> void:
	_data[prefix_str + key] = value

func fetch(key: StringName, default: Variant = null) -> Variant:
	key = prefix_str + key
	if _data.has(key):
		return _data[key]
	_data[key] = default
	return default

func store_rng(key: StringName, value: RandomNumberGenerator) -> void:
	store(key, [value.seed, value.state])

func fetch_rng(key: StringName, rng: RandomNumberGenerator, default_seed := randi()) -> void:
	var arr = fetch(key, [default_seed, 0])
	assert(arr.size() == 2)
	rng.seed = arr[0]
	rng.state = arr[1]

func fetch_flags(key: StringName) -> Dictionary:
	var flag_arr := fetch(key, []) as Array
	var flags := {}
	for flag in flag_arr:
		flags[flag] = true
	return flags

func store_flags(key: StringName, flags: Dictionary) -> void:
	var flag_arr := []
	for flag_name in flags:
		if not flags[flag_name]: continue
		flag_arr.append(flag_name)
	store(key, flag_arr)

func save_to_disk() -> void:
	save_to_cache()
	save_cache_to_disk()

func save_to_cache() -> void:
	_cache = _data.duplicate()

func save_cache_to_disk() -> int:
	var file := FileAccess.open(path, FileAccess.WRITE)
	if not is_instance_valid(file):
		return FileAccess.get_open_error()
	
	match format:
		Format.TextFile:
			var string := var_to_str(_cache)
			file.store_string(string)
			if file.get_error() != OK: return file.get_error()
		Format.BytesFile:
			var bytes := var_to_bytes(_cache)
			file.store_buffer(bytes)
			if file.get_error() != OK: return file.get_error()
	
	file.flush()
	
	return OK

func load_from_disk() -> void:
	load_from_disk_to_cache()
	load_from_cache()

func load_from_cache() -> void:
	_data = _cache.duplicate()

func load_from_disk_to_cache() -> int:
	var file := FileAccess.open(path, FileAccess.READ)
	if not is_instance_valid(file):
		return FileAccess.get_open_error()
	
	match format:
		Format.TextFile:
			var string := file.get_as_text()
			if file.get_error() != OK: return file.get_error()
			_cache = str_to_var(string)
		Format.BytesFile:
			var bytes: PackedByteArray = file.get_buffer(file.get_length())
			if file.get_error() != OK: return file.get_error()
			_cache  = bytes_to_var(bytes)
	
	return OK
