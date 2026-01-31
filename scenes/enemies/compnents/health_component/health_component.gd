extends Node3D

class_name HealthComponent

@export var MAX_HEALTH := 100
var _health: int


func _ready() -> void:
	_health = MAX_HEALTH


## damage entity
## returns true if the entity is dead, otherwise false
func damage(dmg: int) -> bool:
	_health -= dmg
	return _health <= 0
