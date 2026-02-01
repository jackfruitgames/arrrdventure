# Add this scene to a level to autimatically hide the mask when the
# level starts and show the mask once all enemies are dead.
extends Node

@export var mask: Node3D
@export var enemy_container: Node
@export var boss_enemy_scene: PackedScene

var _boss_spawned = false


func _ready() -> void:
	assert(mask != null, "mask not onfigured!")
	assert(enemy_container != null, "enemy_container not onfigured!")
	assert(boss_enemy_scene != null, "boss enemy scene is empty stupid")
	mask.hide()
	enemy_container.child_order_changed.connect(_on_enemy_died)
	_on_enemy_died()


func _on_enemy_died() -> void:
	if enemy_container.get_child_count() == 0:
		if not _boss_spawned:
			_spawn_boss()
		else:
			mask.show()


func _spawn_boss() -> void:
	var boss_enemy: CharacterBody3D = boss_enemy_scene.instantiate()
	boss_enemy.position = mask.position
	enemy_container.add_child(boss_enemy)
	_boss_spawned = true
