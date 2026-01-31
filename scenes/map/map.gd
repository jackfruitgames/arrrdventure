extends Control

func _on_level_1_button_pressed() -> void:
	GlobalSignals.start_level.emit(E.Level.Level1)


func _on_level_2_button_pressed() -> void:
	GlobalSignals.start_level.emit(E.Level.Level2)


func _on_level_3_button_pressed() -> void:
	GlobalSignals.start_level.emit(E.Level.Level3)


func _on_level_4_button_pressed() -> void:
	GlobalSignals.start_level.emit(E.Level.Level4)


func _on_level_5_button_pressed() -> void:
	GlobalSignals.start_level.emit(E.Level.Level5)


func _on_exit_button_pressed() -> void:
	GlobalSignals.exit_game.emit()
	queue_free() # delete this instance
