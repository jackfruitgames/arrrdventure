extends CanvasLayer

@onready var health_bar: ProgressBar = $HealthContainer/VBoxContainer/HealthBar
@onready var dash_container: Control = $DashContainer
@onready var dash_bar: ProgressBar = $DashContainer/VBoxContainer/DashBar
@onready var base_attack_slot: Control = $AbilitiesContainer/HBoxContainer/BaseAttackSlot
@onready var base_attack_bar: ProgressBar = $AbilitiesContainer/HBoxContainer/BaseAttackSlot/VBoxContainer/BaseAttackBar

# Magic slots
@onready var fire_magic_slot: Control = $AbilitiesContainer/HBoxContainer/FireMagicSlot
@onready var fire_magic_bar: ProgressBar = $AbilitiesContainer/HBoxContainer/FireMagicSlot/VBoxContainer/MagicBar
@onready var fire_magic_panel: PanelContainer = $AbilitiesContainer/HBoxContainer/FireMagicSlot

@onready var water_magic_slot: Control = $AbilitiesContainer/HBoxContainer/WaterMagicSlot
@onready var water_magic_bar: ProgressBar = $AbilitiesContainer/HBoxContainer/WaterMagicSlot/VBoxContainer/MagicBar
@onready var water_magic_panel: PanelContainer = $AbilitiesContainer/HBoxContainer/WaterMagicSlot

@onready var air_magic_slot: Control = $AbilitiesContainer/HBoxContainer/AirMagicSlot
@onready var air_magic_bar: ProgressBar = $AbilitiesContainer/HBoxContainer/AirMagicSlot/VBoxContainer/MagicBar
@onready var air_magic_panel: PanelContainer = $AbilitiesContainer/HBoxContainer/AirMagicSlot

@onready var earth_magic_slot: Control = $AbilitiesContainer/HBoxContainer/EarthMagicSlot
@onready var earth_magic_bar: ProgressBar = $AbilitiesContainer/HBoxContainer/EarthMagicSlot/VBoxContainer/MagicBar
@onready var earth_magic_panel: PanelContainer = $AbilitiesContainer/HBoxContainer/EarthMagicSlot

var selected_magic: E.AttackMode = E.AttackMode.Water


func _ready() -> void:
	dash_container.visible = true

	# Abilities
	base_attack_slot.visible = true
	water_magic_slot.visible = GlobalState.unlocked_level >= E.Level.Level2
	earth_magic_slot.visible = GlobalState.unlocked_level >= E.Level.Level3
	air_magic_slot.visible = GlobalState.unlocked_level >= E.Level.Level4
	fire_magic_slot.visible = GlobalState.unlocked_level >= E.Level.Level5

	update_selected_magic(E.AttackMode.Water)


func update_dash_cooldown(current: float, max_cooldown: float) -> void:
	if max_cooldown > 0:
		dash_bar.value = 1.0 - (current / max_cooldown)
	else:
		dash_bar.value = 1.0


func update_magic_cooldown(current: float, max_cooldown: float) -> void:
	var cooldown_value = 1.0
	if max_cooldown > 0:
		cooldown_value = 1.0 - (current / max_cooldown)

	# Update all magic bars with the same cooldown
	fire_magic_bar.value = cooldown_value
	water_magic_bar.value = cooldown_value
	air_magic_bar.value = cooldown_value
	earth_magic_bar.value = cooldown_value


func update_base_attack_cooldown(current: float, max_cooldown: float) -> void:
	if max_cooldown > 0:
		base_attack_bar.value = 1.0 - (current / max_cooldown)
	else:
		base_attack_bar.value = 1.0


func update_selected_magic(magic_type: E.AttackMode) -> void:
	selected_magic = magic_type

	# Create a highlighted style
	var highlight_style = StyleBoxFlat.new()
	highlight_style.bg_color = Color(0.3, 0.3, 0.3, 1.0)
	highlight_style.border_width_left = 3
	highlight_style.border_width_right = 3
	highlight_style.border_width_top = 3
	highlight_style.border_width_bottom = 3
	highlight_style.border_color = Color(1.0, 1.0, 0.0, 1.0)
	highlight_style.corner_radius_top_left = 4
	highlight_style.corner_radius_top_right = 4
	highlight_style.corner_radius_bottom_left = 4
	highlight_style.corner_radius_bottom_right = 4

	# Normal style
	var normal_style = StyleBoxFlat.new()
	normal_style.bg_color = Color(0.2, 0.2, 0.2, 0.8)
	normal_style.corner_radius_top_left = 4
	normal_style.corner_radius_top_right = 4
	normal_style.corner_radius_bottom_left = 4
	normal_style.corner_radius_bottom_right = 4

	# Reset all panels to normal
	fire_magic_panel.add_theme_stylebox_override("panel", normal_style)
	water_magic_panel.add_theme_stylebox_override("panel", normal_style)
	air_magic_panel.add_theme_stylebox_override("panel", normal_style)
	earth_magic_panel.add_theme_stylebox_override("panel", normal_style)

	# Highlight the selected one
	match magic_type:
		E.AttackMode.Fire:
			fire_magic_panel.add_theme_stylebox_override("panel", highlight_style)
		E.AttackMode.Water:
			water_magic_panel.add_theme_stylebox_override("panel", highlight_style)
		E.AttackMode.Air:
			air_magic_panel.add_theme_stylebox_override("panel", highlight_style)
		E.AttackMode.Earth:
			earth_magic_panel.add_theme_stylebox_override("panel", highlight_style)


func update_health(current: int, max_health: int) -> void:
	if max_health > 0:
		health_bar.value = float(current) / float(max_health)
	else:
		health_bar.value = 0.0
