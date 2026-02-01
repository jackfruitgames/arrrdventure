extends Node3D

func _ready() -> void:
	GlobalSignals.dialogue_ended.connect(_on_dialogue_ended)


func _on_dialogue_ended() -> void:
	match GlobalState.unlocked_level:
		E.Level.Level5:
			GlobalSignals.start_level.emit(E.Level.Level5)
		E.Level.End:
			GlobalSignals.exit_game.emit()
			GlobalState.unlocked_level = E.Level.Level1
			queue_free() # delete the map scene
