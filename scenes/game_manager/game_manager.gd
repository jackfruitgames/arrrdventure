extends Node

@export var game_scene: PackedScene
@export var game_container: Node


func _ready() -> void:
	assert(game_scene != null, "No Game Scene configured")
	GlobalSignals.start_game.connect(_on_start_game)


func _on_start_game() -> void:
	var game_instance := game_scene.instantiate()
	game_container.add_child(game_instance)
