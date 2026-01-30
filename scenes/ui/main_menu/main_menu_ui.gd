extends Control

@export var credits_scene: PackedScene
@export var settings_scene: PackedScene


func _ready() -> void:
	assert(credits_scene != null, "Credits scene not set")
	assert(settings_scene != null, "Settings scene not set")
	GlobalSignals.exit_game.connect(_on_exit_game)


func _on_exit_game() -> void:
	show()


func _on_play_button_pressed() -> void:
	GlobalSignals.play_sound.emit(E.Sound.Ui_Click)
	GlobalSignals.start_game.emit()
	hide()


func _on_credits_button_pressed() -> void:
	GlobalSignals.play_sound.emit(E.Sound.Ui_Click)
	add_child(credits_scene.instantiate())


func _on_settings_button_pressed() -> void:
	GlobalSignals.play_sound.emit(E.Sound.Ui_Click)
	add_child(settings_scene.instantiate())
