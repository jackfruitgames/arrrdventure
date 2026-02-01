extends CharacterBody3D

@export var _health_component: HealthBarComponent
@export var ability_scene: PackedScene
@export var ability_cooldown_min: float = 1
@export var ability_cooldown_max: float = 3

var ability_cooldown_timer: float


func _ready() -> void:
	assert(ability_scene != null, "No ability configure!")
	ability_cooldown_timer = randfn(ability_cooldown_min, ability_cooldown_max)


func _physics_process(delta: float) -> void:
	if ability_cooldown_timer > 0:
		ability_cooldown_timer -= delta
	else:
		use_ability()
	return


## damage entity
func damage(dmg: int) -> void:
	if _health_component:
		var is_dead := _health_component.damage(dmg)
		if is_dead:
			_on_dead()
	else:
		printerr("tried to damage an enemy without a health component")


func use_ability() -> void:
	var player: CharacterBody3D = get_tree().get_first_node_in_group("player")
	if player == null:
		printerr("No player found, doing nothing")
		return

	ability_cooldown_timer = randfn(ability_cooldown_min, ability_cooldown_max)

	var ability = ability_scene.instantiate()
	get_tree().root.add_child(ability)

	# Calculate direction toward player
	var direction_to_player = (player.global_position - global_position).normalized()

	# Spawn in direction of the player
	ability.global_position = global_position + direction_to_player * 0.7
	ability.direction = direction_to_player

	# Set source type based on shooter's group
	if "source_group" in ability:
		ability.source_group = "enemy"


func _on_dead() -> void:
	queue_free() # TODO: Epic animation
