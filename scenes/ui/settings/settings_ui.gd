extends Control

func _on_close_button_pressed() -> void:
	GlobalSignals.play_sound.emit(E.Sound.Ui_Click)
	SaveFile.save_game()
	queue_free()
