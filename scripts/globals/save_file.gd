extends Node

const _SAVE_FILE_PATH := "user://game_save.cfg"
const _GAME_SECTION := "GAME"
const _SETTINGS_SECTION := "SETTINGS"

var _config_file := ConfigFile.new()


func _init() -> void:
	var err := _config_file.load(_SAVE_FILE_PATH)
	if err != OK:
		return # nothing no load, start with default game state

	# SETTINGS
	GlobalSettings.audio_volumes_pct = _config_file.get_value(_SETTINGS_SECTION, "audio_volumes_pct", GlobalSettings.audio_volumes_pct)


func save_game() -> void:
	# SETTINGS
	_config_file.set_value(_SETTINGS_SECTION, "audio_volumes_pct", GlobalSettings.audio_volumes_pct)

	var err := _config_file.save(_SAVE_FILE_PATH)
	if err != OK:
		printerr("Saving game failed", err)
