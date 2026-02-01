extends Node3D

class_name HealthBarComponent

@export var MAX_HEALTH := 100

@export var bar_width: float = 50.0
@export var bar_height: float = 8.0
@export var y_offset: float = 1.0

@onready var _sprite: Sprite3D = $Sprite3D
@onready var _viewport: SubViewport = $SubViewport
@onready var _progress_bar: ProgressBar = $SubViewport/ProgressBar
var _health: int

signal health_changed(current_health: int, max_health: int)


func _ready() -> void:
	_setup_viewport()
	_setup_sprite()
	_health = MAX_HEALTH
	health_changed.connect(_on_health_changed)
	health_changed.emit(_health, MAX_HEALTH)


## damage entity
## returns true if the entity is dead, otherwise false
func damage(dmg: int) -> bool:
	_health -= dmg
	health_changed.emit(_health, MAX_HEALTH)
	return _health <= 0


## returns health as a percentage (0.0 to 1.0)
func get_health_percent() -> float:
	if MAX_HEALTH > 0:
		return float(_health) / float(MAX_HEALTH)
	return 0.0


func _setup_viewport() -> void:
	_viewport.size = Vector2i(int(bar_width), int(bar_height))
	_viewport.transparent_bg = true

	_progress_bar.custom_minimum_size = Vector2(bar_width, bar_height)
	_progress_bar.size = Vector2(bar_width, bar_height)


func _setup_sprite() -> void:
	_sprite.texture = _viewport.get_texture()
	_sprite.position.y = y_offset
	_sprite.pixel_size = 0.01


func _on_health_changed(current_health: int, max_health: int) -> void:
	if max_health > 0:
		_progress_bar.value = float(current_health) / float(max_health) * 100.0
	else:
		_progress_bar.value = 0.0
