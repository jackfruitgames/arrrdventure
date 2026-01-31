extends Node3D

@export var _hitbox_component: HitboxComponent


func _ready() -> void:
	_hitbox_component.dead.connect(_on_dead)


func _on_dead() -> void:
	print("enemy dead")
	queue_free() # TODO: Epic animation
