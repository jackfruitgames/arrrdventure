extends Node

@export var map_scene: PackedScene
@export var level_scenes: Array[PackedScene]
@export var game_container: Node


func _ready() -> void:
	assert(map_scene != null, "No Game Scene configured")
	GlobalSignals.start_game.connect(_on_start_game)
	GlobalSignals.start_level.connect(_on_start_level)
	GlobalSignals.finish_level.connect(_on_finished_level)


func _on_start_game() -> void:
	var map_instance := map_scene.instantiate()
	game_container.add_child(map_instance)


func _clear_game_container() -> void:
	# remove the map or any other nodes from the game container
	for child in game_container.get_children():
		child.queue_free()


func _on_start_level(level_idx: E.Level) -> void:
	# don't do anything if the level is not configured
	if len(level_scenes) < level_idx + 1:
		printerr("Level %s not configured!" % (level_idx + 1))
		return

	_clear_game_container()

	var level_instance := level_scenes[level_idx].instantiate()
	game_container.add_child(level_instance)


func _on_finished_level(level_idx: E.Level) -> void:
	print("Finished level...")
	GlobalState.unlocked_level = level_idx
	_clear_game_container()

	# load map again
	var map_instance := map_scene.instantiate()
	game_container.add_child(map_instance)
