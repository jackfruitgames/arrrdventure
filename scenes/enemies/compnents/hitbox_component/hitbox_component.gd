extends Area3D

class_name HitboxComponent

@export var HEALTH_COMPONENT: HealthComponent

signal dead()


## damage entity
## returns true if the entity is dead, otherwise false
func damage(dmg: int) -> bool:
	if HEALTH_COMPONENT:
		var is_dead := HEALTH_COMPONENT.damage(dmg)
		if is_dead:
			dead.emit()
		return is_dead
	printerr("tried to damage an entity without a health component")
	return false
