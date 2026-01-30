extends Node

@export var ui_click: AudioStream


func _ready() -> void:
	assert(ui_click != null, "ui_click audio missing")
	GlobalSignals.play_sound.connect(_on_play_sound)
	# initialize the volume of each audio bus
	for bus_idx: int in E.AudioBus.values():
		AudioServer.set_bus_volume_linear(bus_idx, GlobalSettings.audio_volumes_pct[bus_idx] / 100.0) # linear volume = 0 - 1


func _on_play_sound(sound: E.Sound) -> void:
	# make sure to use the correct audio stream player!
	match sound:
		E.Sound.Ui_Click:
			$UiAudioStreamPlayer.stream = ui_click
			$UiAudioStreamPlayer.play()
		_:
			printerr("Sound not configured: %s" % E.Sound.keys()[sound])
