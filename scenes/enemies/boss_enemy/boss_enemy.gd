extends CharacterBody3D

@export var _health_component: HealthBarComponent
@export var ability_scene: PackedScene

# Phase configuration
@export_group("Phase 1 (100%-75% HP)")
@export var phase1_cooldown_min: float = 2.0
@export var phase1_cooldown_max: float = 3.0
@export var phase1_move_speed: float = 100.0

@export_group("Phase 2 (75%-50% HP)")
@export var phase2_cooldown_min: float = 1.5
@export var phase2_cooldown_max: float = 2.0
@export var phase2_move_speed: float = 125.0

@export_group("Phase 3 (50%-25% HP)")
@export var phase3_cooldown_min: float = 1.0
@export var phase3_cooldown_max: float = 1.5
@export var phase3_move_speed: float = 150
@export var phase3_use_spread: bool = true

@export_group("Phase 4 (25%-0% HP) - ENRAGE")
@export var phase4_cooldown_min: float = 0.5
@export var phase4_cooldown_max: float = 1.0
@export var phase4_move_speed: float = 175
@export var phase4_use_spread: bool = true
@export var phase4_spread_count: int = 5

enum BossPhase {
	PHASE_1, # 100%-75%
	PHASE_2, # 75%-50%
	PHASE_3, # 50%-25%
	PHASE_4, # 25%-0% ENRAGE
}

var current_phase: BossPhase = BossPhase.PHASE_1
var ability_cooldown_timer: float = 0.0
var current_move_speed: float = 20.0

@onready var movement_component: Node = $MiniMovement


func _ready() -> void:
	assert(ability_scene != null, "No ability configured!")
	_update_phase()
	ability_cooldown_timer = _get_random_cooldown()


func _physics_process(delta: float) -> void:
	# Update phase based on health
	_update_phase()

	# Handle ability cooldown
	if ability_cooldown_timer > 0:
		ability_cooldown_timer -= delta
	else:
		use_ability()


func _update_phase() -> void:
	if not _health_component:
		return

	var health_percent = _health_component.get_health_percent()
	var new_phase = current_phase

	if health_percent > 0.75:
		new_phase = BossPhase.PHASE_1
	elif health_percent > 0.50:
		new_phase = BossPhase.PHASE_2
	elif health_percent > 0.25:
		new_phase = BossPhase.PHASE_3
	else:
		new_phase = BossPhase.PHASE_4

	# Check if phase changed
	if new_phase != current_phase:
		current_phase = new_phase
		_on_phase_changed()


func _on_phase_changed() -> void:
	# Update movement speed based on phase
	match current_phase:
		BossPhase.PHASE_1:
			current_move_speed = phase1_move_speed
		BossPhase.PHASE_2:
			current_move_speed = phase2_move_speed
		BossPhase.PHASE_3:
			current_move_speed = phase3_move_speed
		BossPhase.PHASE_4:
			current_move_speed = phase4_move_speed

	# Update the movement component's fspeed
	if movement_component and "speed" in movement_component:
		movement_component.speed = int(current_move_speed)

	# Visual/audio feedback (optional - can be expanded later)
	print("Boss entered Phase ", current_phase + 1, " - Speed: ", current_move_speed)


func _get_random_cooldown() -> float:
	match current_phase:
		BossPhase.PHASE_1:
			return randf_range(phase1_cooldown_min, phase1_cooldown_max)
		BossPhase.PHASE_2:
			return randf_range(phase2_cooldown_min, phase2_cooldown_max)
		BossPhase.PHASE_3:
			return randf_range(phase3_cooldown_min, phase3_cooldown_max)
		BossPhase.PHASE_4:
			return randf_range(phase4_cooldown_min, phase4_cooldown_max)
	return 2.0


func use_ability() -> void:
	var player: CharacterBody3D = get_tree().get_first_node_in_group("player")
	if player == null:
		printerr("No player found, doing nothing")
		return

	ability_cooldown_timer = _get_random_cooldown()

	# Calculate direction toward player
	var direction_to_player = (player.global_position - global_position).normalized()

	# Check if this phase uses spread shot
	var use_spread = (current_phase == BossPhase.PHASE_3 and phase3_use_spread) or \
	(current_phase == BossPhase.PHASE_4 and phase4_use_spread)

	if use_spread:
		_shoot_spread(direction_to_player)
	else:
		_shoot_single(direction_to_player)


func _shoot_single(direction: Vector3) -> void:
	var ability = ability_scene.instantiate()
	get_tree().root.add_child(ability)

	ability.global_position = global_position + direction * 0.7
	ability.direction = direction

	if "source_group" in ability:
		ability.source_group = "enemy"


func _shoot_spread(base_direction: Vector3) -> void:
	var spread_count = phase4_spread_count if current_phase == BossPhase.PHASE_4 else 3
	var spread_angle = deg_to_rad(90.0) # Total spread angle (wide spread for visibility)

	# Cache boss position to avoid multiple global_position calls during loop
	var spawn_position = global_position

	for i in range(spread_count):
		# Calculate angle offset for this projectile (-0.5 to 0.5 of spread_angle)
		var angle_offset = spread_angle * (float(i) / (spread_count - 1) - 0.5)

		# Rotate base direction around Y axis (UP) for horizontal spread
		var rotated_direction = base_direction.rotated(Vector3.UP, angle_offset)

		# Create and add ability (must add to tree before setting global_position)
		var ability = ability_scene.instantiate()
		get_tree().root.add_child(ability)

		# Now set properties (same order as _shoot_single)
		# Use larger offset for spread shots to prevent collision overlap
		var spawn_offset = 1.5 if spread_count > 3 else 0.7
		ability.global_position = spawn_position + rotated_direction * spawn_offset
		ability.direction = rotated_direction

		if "source_group" in ability:
			ability.source_group = "enemy"


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
