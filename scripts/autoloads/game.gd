extends CanvasLayer

signal store(ds: DataStore)
signal fetch(ds: DataStore)

signal player_dying()
signal player_died()
signal boss_defeated(boss: Node)

@export var player_scene: PackedScene
@export var map_scene: PackedScene

var save_index := 0
var ds: DataStore = DataStore.new()
var player: Player
var player_has_control: bool

func _enter_tree() -> void:
	player_died.connect(_on_player_died)
	player_dying.connect(_on_player_dying)

func _ready() -> void:
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
	
	var current_scene := get_tree().current_scene
	if current_scene.get_child_count() != 0:
		print('Editor forced loading a diffrent map: ' + current_scene.scene_file_path)
		map_scene = load(current_scene.scene_file_path)
	
	reload.call_deferred()
	
	# For editor purposes...
	get_window().grab_focus()
	get_window().move_to_foreground()
	get_window().mode = Window.MODE_FULLSCREEN
	get_tree().create_timer(0.25).timeout.connect(func():
		get_window().grab_focus()
		get_window().move_to_foreground()
	)

func save() -> void:
	print('GAME: Saving...')
	store.emit(ds)
	ds.save_to_disk()

func reload() -> void:
	print('GAME: Reloading...')
	randomize()
	player_has_control = false
	
	# unload map
	ds.load_from_cache()
	get_tree().unload_current_scene()
	
	# unload player
	if is_instance_valid(player):
		get_tree().root.remove_child(player)
		player.queue_free()
		player = null
	
	#await get_tree().process_frame
	
	# spawn player
	player = player_scene.instantiate() as Player
	get_tree().root.add_child(player)
	
	# load level
	get_tree().change_scene_to_packed(map_scene)
	
	#await get_tree().process_frame
	
	fetch.emit(ds)
	
	player_has_control = true
	
	Camera.target_player()
	Camera.center_camera()

func _on_player_dying() -> void:
	pause()

func _on_player_died() -> void:
	print('GAME: Player died!')
	reload()
	ds.store('counter.deaths', ds.fetch('counter.deaths', 0) + 1)
	ds.save_to_disk()
	unpause()

var pause_locks := 0
func pause():
	pause_locks += 1
	get_tree().paused = pause_locks > 0

func unpause():
	assert(pause_locks > 0)
	pause_locks -= 1
	get_tree().paused = pause_locks > 0

func goto_room(target: Marker2D) -> void:
	player.position = target.global_position
	Camera.target_player()
	Camera.center_camera()
