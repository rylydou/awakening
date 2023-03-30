extends CanvasLayer

signal store(ds: DataStore)
signal fetch(ds: DataStore)

signal enter_room()
signal player_died()

@export var player_scene: PackedScene
@export var map_scene: PackedScene

var save_index := 0
var ds: DataStore = DataStore.new()
var player: Player
var player_has_control: bool

func _enter_tree() -> void:
	player_died.connect(_on_player_died)

func _ready() -> void:
	# load map
	get_tree().change_scene_to_packed(map_scene)
	
	ds.format = DataStore.Format.TextFile
	ds.path = 'user://save%s.json' % [save_index + 1]
	ds.load_from_disk()
	
	var status_code := DFU.fix(ds)
	if status_code >= DFU.StatusCode.Error:
		# An error ocurred. Just make a new file but don't save the new file.
		printerr('Error fixing save data: %s' % status_code)
		ds.clear()
		DFU.fix(ds)
	elif status_code > DFU.StatusCode.Ok_Created:
		# The DFU fixed the save data. Make a backup of the old data.
		ds.path = 'user://save%s_backup.json' % [save_index + 1]
		ds.save_cache_to_disk()
		ds.path = 'user://save%s.json' % [save_index + 1]
	elif status_code == DFU.StatusCode.Ok_Created:
		# Creating a new save. Save it to disk.
		ds.save_to_disk()
	
	reload.call_deferred()

func save() -> void:
	print('GAME: Saving...')
	store.emit(ds)
	ds.save_to_disk()

func reload() -> void:
	print('GAME: Reloading...')
	if is_instance_valid(player):
		get_tree().root.remove_child(player)
		player.queue_free()
		player = null
	
	randomize()
	ds.load_from_cache()
	get_tree().reload_current_scene()
	
	await get_tree().process_frame
	
	# spawn player
	player = player_scene.instantiate() as Player
	var start_marker := get_tree().current_scene.find_child('Start') as Marker2D
	if is_instance_valid(start_marker):
		player.position = start_marker.global_position
	get_tree().root.add_child(player)
	
	fetch.emit(ds)
	
	Camera.target_room()
	Camera.center_camera()
	
	player_has_control = true

func _on_player_died() -> void:
	print('GAME: Player died!')
	reload()
	ds.store('counter.deaths', ds.fetch_int('counter.deaths', 0) + 1)
	ds.save_to_disk()

var pause_locks := 0
func pause():
	pause_locks += 1
	get_tree().paused = pause_locks > 0

func unpause():
	assert(pause_locks > 0)
	pause_locks -= 1
	get_tree().paused = pause_locks > 0
