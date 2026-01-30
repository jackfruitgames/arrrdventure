extends HBoxContainer

@export var audio_bus: E.AudioBus = E.AudioBus.Master


func _ready() -> void:
	$Label.text = "%s volume:" % E.AudioBus.keys()[audio_bus]
	$VolumeSlider.value = GlobalSettings.audio_volumes_pct[audio_bus]


func _on_volume_slider_value_changed(volume_pct: float) -> void:
	if GlobalSettings.audio_volumes_pct[audio_bus] != int(volume_pct):
		GlobalSettings.audio_volumes_pct[audio_bus] = int(volume_pct)
		AudioServer.set_bus_volume_linear(audio_bus, volume_pct / 100) # linear = 0 - 1
		print("%s volume = %s (linear)" % [AudioServer.get_bus_name(audio_bus), AudioServer.get_bus_volume_linear(audio_bus)])


func _on_volume_slider_drag_ended(_value_changed: bool) -> void:
	match audio_bus:
		E.AudioBus.Master:
			return # music should already be playing for immediate feedback
		E.AudioBus.Music:
			return # music should already be playing for immediate feedback
		E.AudioBus.Sfx:
			return # TODO: play some SFX sound
		E.AudioBus.UI:
			GlobalSignals.play_sound.emit(E.Sound.Ui_Click)
		_:
			printerr("Did you add a new audio bus?")
			return
