extends Node3D

var _score := 0


func _on_exit_button_pressed() -> void:
	GlobalSignals.play_sound.emit(E.Sound.Ui_Click)
	GlobalSignals.exit_game.emit()
	queue_free()
