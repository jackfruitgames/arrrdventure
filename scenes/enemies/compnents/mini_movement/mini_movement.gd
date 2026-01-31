extends Node

@export var entity_to_move: Node3D


func _physics_process(delta: float) -> void:
	var player: CharacterBody3D = get_tree().get_first_node_in_group("player")
	var distance := player.position.distance_to(entity_to_move.position)
	var original_y := entity_to_move.position.y
	if distance > 4:
		entity_to_move.position = entity_to_move.position.move_toward(player.position, delta)
	elif distance < 3:
		entity_to_move.position = entity_to_move.position.move_toward(player.position, -delta)
	entity_to_move.position.y = original_y
