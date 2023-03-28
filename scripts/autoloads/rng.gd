extends Node

var game := RandomNumberGenerator.new()
var world := RandomNumberGenerator.new()
var player := RandomNumberGenerator.new()
var ai := RandomNumberGenerator.new()
var drop := RandomNumberGenerator.new()
var loot := RandomNumberGenerator.new()
var misc := RandomNumberGenerator.new()

func _ready() -> void:
	Game.store.connect(store)
	Game.fetch.connect(fetch)

func store(ds: DataStore) -> void:
	ds.push_prefix('rng')
	ds.store_rng('game', game)
	ds.store_rng('world', world)
	ds.store_rng('player', world)
	ds.store_rng('ai', ai)
	ds.store_rng('drop', drop)
	ds.store_rng('loot', loot)
	ds.store_rng('misc', misc)
	ds.pop_prefix()

func fetch(ds: DataStore) -> void:
	ds.push_prefix('rng')
	ds.fetch_rng('game', game)
	ds.fetch_rng('world', world)
	ds.fetch_rng('player', world)
	ds.fetch_rng('ai', ai)
	ds.fetch_rng('drop', drop)
	ds.fetch_rng('loot', loot)
	ds.fetch_rng('misc', misc)
	ds.pop_prefix()
