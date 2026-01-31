extends Node

@export var entity_to_move: CharacterBody3D
@export var speed: int = 100

var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")


func _physics_process(delta: float) -> void:
	# if we don't have a player, don't move
	var player: CharacterBody3D = get_tree().get_first_node_in_group("player")
	if player == null:
		return

	# Apply gravity
	if not entity_to_move.is_on_floor():
		entity_to_move.velocity.y -= gravity * delta

	var distance := player.position.distance_to(entity_to_move.position)
	if distance > 4:
		var direction := (player.position - entity_to_move.position).normalized()
		entity_to_move.velocity.x = direction.x * delta * speed
		entity_to_move.velocity.z = direction.z * delta * speed
		entity_to_move.move_and_slide()
	elif distance < 3:
		var direction := (entity_to_move.position - player.position).normalized()
		entity_to_move.velocity.x = direction.x * delta * 100
		entity_to_move.velocity.z = direction.z * delta * 100
		entity_to_move.move_and_slide()
