extends Node

var audio_volumes_pct: Dictionary[E.AudioBus, int] = {
	E.AudioBus.Master: 50,
	E.AudioBus.Music: 100,
	E.AudioBus.Sfx: 100,
	E.AudioBus.UI: 100,
}
