extends Node

@export var ui_click: AudioStream


func _ready() -> void:
	assert(ui_click != null, "ui_click audio missing")
	GlobalSignals.play_sound.connect(_on_play_sound)
	GlobalSignals.start_level.connect(_on_start_level)
	GlobalSignals.finish_level.connect(_on_finish_level)
	GlobalSignals.boss_spawned.connect(_on_boss_spawned)
	$MainMusicAudioStreamPlayer.finished.connect(_play_main_menu_music)
	$BossWaterMusicAudioStreamPlayer.finished.connect(_on_water_finished)
	$BossEarthMusicAudioStreamPlayer.finished.connect(_on_earth_finished)
	$BossWindMusicAudioStreamPlayer.finished.connect(_on_wind_finished)
	$BossFireMusicAudioStreamPlayer.finished.connect(_on_fire_finished)
	$EndBossMusicAudioStreamPlayer.finished.connect(_on_end_boss_finished)
	# initialize the volume of each audio bus
	for bus_idx: int in E.AudioBus.values():
		AudioServer.set_bus_volume_linear(bus_idx, GlobalSettings.audio_volumes_pct[bus_idx] / 100.0) # linear volume = 0 - 1
	_play_main_menu_music_loop_with_pre_roll()


func _on_water_finished() -> void:
	$BossWaterMusicAudioStreamPlayer.play()


func _on_earth_finished() -> void:
	$BossEarthMusicAudioStreamPlayer.play()


func _on_wind_finished() -> void:
	$BossWindMusicAudioStreamPlayer.play()


func _on_fire_finished() -> void:
	$BossFireMusicAudioStreamPlayer.play()


func _on_end_boss_finished() -> void:
	$EndBossMusicAudioStreamPlayer.play()


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


func _on_start_level(level: E.Level) -> void:
	await _fade_out_music()
	$MainMusicAudioStreamPlayer.stop()
	_reset_volume()
	$BattleMusicAudioStreamPlayer.play()


func _on_finish_level(level: E.Level) -> void:
	await _fade_out_music()
	# it's time to stop
	$BossWaterMusicAudioStreamPlayer.stop()
	$BossEarthMusicAudioStreamPlayer.stop()
	$BossWindMusicAudioStreamPlayer.stop()
	$BossFireMusicAudioStreamPlayer.stop()
	$EndBossMusicAudioStreamPlayer.stop()
	_reset_volume()
	_play_main_menu_music_loop_with_pre_roll()


func _on_boss_spawned(element: E.Element) -> void:
	var playback_pos: float = $BattleMusicAudioStreamPlayer.get_playback_position()
	match element:
		E.Element.Water:
			$BossWaterMusicAudioStreamPlayer.play(playback_pos)
		E.Element.Fire:
			$BossFireMusicAudioStreamPlayer.play(playback_pos)
		E.Element.Earth:
			$BossEarthMusicAudioStreamPlayer.play(playback_pos)
		E.Element.Wind:
			$BossWindMusicAudioStreamPlayer.play(playback_pos)
		E.Element.All:
			$EndBossMusicAudioStreamPlayer.play(playback_pos)

	$BattleMusicAudioStreamPlayer.stop()


func _reset_volume() -> void:
	AudioServer.set_bus_volume_linear(
		E.AudioBus.Music,
		GlobalSettings.audio_volumes_pct[E.AudioBus.Music] / 100,
	)


func _fade_out_music() -> void:
	var tween := create_tween()
	var current_volume := AudioServer.get_bus_volume_db(E.AudioBus.Music)
	tween.tween_method(
		func(volume_db: float) -> void:
			AudioServer.set_bus_volume_db(E.AudioBus.Music, volume_db),
		current_volume,
		-80.0, # -80 dB is effectively silent
		1.0, # fade duration in seconds
	)
	await tween.finished
