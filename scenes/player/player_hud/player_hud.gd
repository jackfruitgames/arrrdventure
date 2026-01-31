extends CanvasLayer

@onready var dash_container: Control = $DashContainer
@onready var dash_bar: ProgressBar = $DashContainer/VBoxContainer/DashBar
@onready var fireball_slot: Control = $AbilitiesContainer/HBoxContainer/FireballSlot
@onready var fireball_bar: ProgressBar = $AbilitiesContainer/HBoxContainer/FireballSlot/VBoxContainer/FireballBar
@onready var arrow_slot: Control = $AbilitiesContainer/HBoxContainer/ArrowSlot
@onready var arrow_bar: ProgressBar = $AbilitiesContainer/HBoxContainer/ArrowSlot/VBoxContainer/ArrowBar


func _ready() -> void:
	dash_container.visible = true

	# Abilities
	arrow_slot.visible = GlobalState.unlocked_level >= E.Level.Level1
	fireball_slot.visible = GlobalState.unlocked_level >= E.Level.Level2


func update_dash_cooldown(current: float, max_cooldown: float) -> void:
	if max_cooldown > 0:
		dash_bar.value = 1.0 - (current / max_cooldown)
	else:
		dash_bar.value = 1.0


func update_fireball_cooldown(current: float, max_cooldown: float) -> void:
	if max_cooldown > 0:
		fireball_bar.value = 1.0 - (current / max_cooldown)
	else:
		fireball_bar.value = 1.0


func update_arrow_cooldown(current: float, max_cooldown: float) -> void:
	if max_cooldown > 0:
		arrow_bar.value = 1.0 - (current / max_cooldown)
	else:
		arrow_bar.value = 1.0
