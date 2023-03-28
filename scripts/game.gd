extends CanvasLayer

signal store(ds: DataStore)
signal fetch(ds: DataStore)

@export var player_scene: PackedScene

var ds: DataStore = DataStore.new()
var player: Player
var player_has_control := true

func _ready() -> void:
	ds.format = DataStore.Format.TextFile
	ds.path = 'user://save1.json'
	ds.load_from_disk()
	DFU.fix(ds)
	
	randomize()
	reload.call_deferred()

func save() -> void:
	store.emit(ds)
	ds.save_to_disk()

func reload() -> void:
	randomize()
	fetch.emit(ds)
	await get_tree().process_frame
	spawn_player()

func spawn_player() -> void:
	player = player_scene.instantiate()
	get_tree().root.add_child(player)
