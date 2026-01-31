extends CharacterBody3D

@export var _health_component: HealthBarComponent


## damage entity
func damage(dmg: int) -> void:
	if _health_component:
		var is_dead := _health_component.damage(dmg)
		if is_dead:
			_on_dead()
	else:
		printerr("tried to damage an enemy without a health component")


func _on_dead() -> void:
	queue_free() # TODO: Epic animation
