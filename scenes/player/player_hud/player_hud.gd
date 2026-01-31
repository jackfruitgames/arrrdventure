extends CanvasLayer

@onready var dash_bar: ProgressBar = $DashContainer/VBoxContainer/DashBar


func update_dash_cooldown(current: float, max_cooldown: float) -> void:
	if max_cooldown > 0:
		dash_bar.value = 1.0 - (current / max_cooldown)
	else:
		dash_bar.value = 1.0
