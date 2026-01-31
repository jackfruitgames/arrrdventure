# Add this scene to a level to autimatically hide the mask when the
# level starts and show the mask once all enemies are dead.
extends Node

@export var mask: Node3D
@export var enemy_container: Node


func _ready() -> void:
	assert(mask != null, "mask not onfigured!")
	assert(enemy_container != null, "enemy_container not onfigured!")
	mask.hide()
	enemy_container.child_order_changed.connect(_on_enemy_died)


func _on_enemy_died() -> void:
	if enemy_container.get_child_count() == 0:
		mask.show()
