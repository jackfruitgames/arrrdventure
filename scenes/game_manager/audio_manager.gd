extends Node

@export var ui_click: AudioStream


func _ready() -> void:
	assert(ui_click != null, "ui_click audio missing")
	GlobalSignals.play_sound.connect(_on_play_sound)
	# initialize the volume of each audio bus
	for bus_idx: int in E.AudioBus.values():
		AudioServer.set_bus_volume_linear(bus_idx, GlobalSettings.audio_volumes_pct[bus_idx] / 100.0) # linear volume = 0 - 1
	_on_main_menu_pre_roll_finished()
	#$MainMusicPreRollAudioStreamPlayer.finished.connect(_on_main_menu_pre_roll_finished)
	#$MainMusicAudioStreamPlayer.finished.connect(_on_main_menu_loop_finished)


func _on_main_menu_pre_roll_finished() -> void:
	var timer := Timer.new()
	timer.wait_time = 0.9
	timer.start()
	$MainMusicPreRollAudioStreamPlayer.play()
	await timer.timeout
	timer.stop()
	$MainMusicAudioStreamPlayer.play(1.0)
	timer.wait_time = 0.05
	timer.start()
	await timer.timeout
	$MainMusicPreRollAudioStreamPlayer.stop()
	timer.stop()


func _on_main_menu_loop_finished() -> void:
	$MainMusicAudioStreamPlayer.play()


func _on_play_sound(sound: E.Sound) -> void:
	# make sure to use the correct audio stream player!
	match sound:
		E.Sound.Ui_Click:
			$UiAudioStreamPlayer.stream = ui_click
			$UiAudioStreamPlayer.play()
		_:
			printerr("Sound not configured: %s" % E.Sound.keys()[sound])
