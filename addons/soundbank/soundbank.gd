extends Node

const SOUND_BANK_FOLDER := 'res://content/sounds/'
const FALLBACK_SOUND: AudioStreamWAV = preload('./fallback.wav')
const POOL_SIZE_2D := 16.
const POOL_SIZE_UI := 8.

var bank := {}

var next_pool_index_2d := 0
var player_pool_2d: Array[AudioStreamPlayer2D] = []
func get_player_2d() -> AudioStreamPlayer2D:
	var player := player_pool_2d[next_pool_index_2d]
	next_pool_index_2d += 1
	if next_pool_index_2d >= player_pool_2d.size():
		next_pool_index_2d = 0
	return player
func generate_pool_2d(count: int) -> void:
	for i in count:
		var player := AudioStreamPlayer2D.new()
		add_child(player)
		player_pool_2d.append(player)

var next_pool_index_ui := 0
var player_pool_ui: Array[AudioStreamPlayer] = []
func get_player_ui() -> AudioStreamPlayer:
	var player := player_pool_ui[next_pool_index_ui]
	next_pool_index_ui += 1
	if next_pool_index_ui >= player_pool_ui.size():
		next_pool_index_ui = 0
	return player
func generate_pool_ui(count: int) -> void:
	for i in count:
		var player := AudioStreamPlayer.new()
		add_child(player)
		player_pool_ui.append(player)

func _ready() -> void:
	generate_pool_2d(POOL_SIZE_2D)
	generate_pool_ui(POOL_SIZE_UI)
	if not DirAccess.dir_exists_absolute(SOUND_BANK_FOLDER):
		printerr('ERROR IN SOUNDBANK ADDON: sound bank folder not found at %s' % SOUND_BANK_FOLDER)

var loaded_sounds := {}
func get_sound(name: String) -> AudioStream:
	if loaded_sounds.has(name):
		return loaded_sounds[name]
	
	var sound := FALLBACK_SOUND
	var segs := name.split('.')
	
	while segs.size() > 0:
		var path := SOUND_BANK_FOLDER + '.'.join(segs) + '.wav'
		if FileAccess.file_exists(path + '.import'):
			sound = load(path)
			break
		segs.remove_at(segs.size() - 1)
	
	loaded_sounds[name] = sound
	return sound

func play(name: String, position: Vector2, bus: StringName = &'Game') -> void:
	var player := get_player_2d()
	var sound := get_sound(name)
	player.stop()
	player.stream = sound
	player.position = position
	player.pitch_scale = randf_range(0.9, 1.1)
	player.volume_db = randf_range(-2.5, 2.5)
	player.bus = bus
	player.play()

func play_ui(name: String, bus: StringName = &'UI') -> void:
	var player := get_player_ui()
	var sound := get_sound(name)
	player.stop()
	player.stream = sound
	player.bus = bus
	player.play()
