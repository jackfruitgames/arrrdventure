extends Node

@export var ui_click: AudioStream


func _ready() -> void:
	assert(ui_click != null, "ui_click audio missing")
	GlobalSignals.play_sound.connect(_on_play_sound)
	$MainMusicAudioStreamPlayer.finished.connect(_play_main_menu_music)
	# initialize the volume of each audio bus
	for bus_idx: int in E.AudioBus.values():
		AudioServer.set_bus_volume_linear(bus_idx, GlobalSettings.audio_volumes_pct[bus_idx] / 100.0) # linear volume = 0 - 1
	_play_main_menu_music_loop_with_pre_roll()


func _play_main_menu_music_loop_with_pre_roll() -> void:
	# timers can only run when added to the scene tree
	var timer := Timer.new()
	add_child(timer)
	# the actual pre-roll is 1s long, the file is longer to smoothely fade with the loop
	timer.wait_time = 0.8
	timer.start()
	# start the pre roll and wait
	$MainMusicPreRollAudioStreamPlayer.play()
	await timer.timeout
	timer.stop()
	# start the loop while the pre-roll is still fading out
	$MainMusicAudioStreamPlayer.play()
	timer.queue_free()


## manual loop because godot can't loop wav files
## but we need wav files to import them lossless for smooth loops
func _play_main_menu_music() -> void:
	$MainMusicAudioStreamPlayer.play()


func _on_play_sound(sound: E.Sound) -> void:
	# make sure to use the correct audio stream player!
	match sound:
		E.Sound.Ui_Click:
			$UiAudioStreamPlayer.stream = ui_click
			$UiAudioStreamPlayer.play()
		_:
			printerr("Sound not configured: %s" % E.Sound.keys()[sound])
