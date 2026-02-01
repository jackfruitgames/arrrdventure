# Add this scene to a level to automatically hide the mask when the
# level starts and show the mask once all enemies are dead.
extends Node

class_name EnemyManager

# Wave configuration class
class Wave:
	var enemy_count_min: int
	var enemy_count_max: int
	var wave_duration: float # 0 means no timer, just wait for all enemies to die
	var enemy_scene: PackedScene


	func _init(p_enemy_scene: PackedScene, p_count_min: int, p_count_max: int, p_duration: float = 0.0):
		enemy_scene = p_enemy_scene
		enemy_count_min = p_count_min
		enemy_count_max = p_count_max
		wave_duration = p_duration


@export var mask: Node3D
@export var enemy_container: Node
@export var boss_enemy_scene: PackedScene
@export var mini_enemy_scene: PackedScene
@export var spawn_radius: float = 10.0

var waves: Array[Wave] = []
var current_wave_index: int = 0
var wave_timer: float = 0.0
var wave_active: bool = false
var _boss_spawned: bool = false


func _ready() -> void:
	assert(mask != null, "mask not configured!")
	assert(enemy_container != null, "enemy_container not configured!")
	assert(boss_enemy_scene != null, "boss enemy scene is empty stupid")
	assert(mini_enemy_scene != null, "mini_enemy_scene not configured!")

	mask.hide()
	enemy_container.child_order_changed.connect(_on_enemy_died)

	# Configure waves (can be overridden by child classes or in-editor)
	_configure_waves()

	# Start first wave
	_spawn_wave()


# Override this function in level-specific scripts to customize waves
func _configure_waves() -> void:
	# Wave parameters:
	# - enemy_scene: PackedScene to spawn
	# - count_min: Minimum number of enemies
	# - count_max: Maximum number of enemies
	# - duration: Time in seconds before next wave (0 = wait for all enemies to die)
	#
	# Example for more complex levels:
	# waves.append(Wave.new(mini_enemy_scene, 5, 7, 30.0))  # 5-7 enemies, 30s timer
	# waves.append(Wave.new(mini_enemy_scene, 3, 4, 20.0))  # 3-4 enemies, 20s timer
	# waves.append(Wave.new(mini_enemy_scene, 6, 8, 0.0))   # 6-8 enemies, no timer

	# Example wave: 4-5 enemies, wait 30 seconds until the next wave
	waves.append(Wave.new(mini_enemy_scene, 1, 1, 30.0))


func _process(delta: float) -> void:
	if wave_active and waves[current_wave_index].wave_duration > 0:
		wave_timer += delta
		if wave_timer >= waves[current_wave_index].wave_duration:
			_advance_wave()


func _on_enemy_died() -> void:
	# Check if all enemies are dead
	if enemy_container.get_child_count() <= 0:
		# If boss has been spawned and defeated, show mask
		if _boss_spawned:
			mask.show()
		else:
			_advance_wave()


func _advance_wave() -> void:
	if not wave_active:
		return

	wave_active = false
	current_wave_index += 1

	# Check if there are more waves
	if current_wave_index < waves.size():
		_spawn_wave()
	elif not _boss_spawned:
		_spawn_boss()
	else:
		mask.show()


func _spawn_wave() -> void:
	if current_wave_index >= waves.size():
		return

	var wave = waves[current_wave_index]
	var enemy_count = randi_range(wave.enemy_count_min, wave.enemy_count_max)

	# Preload all ability scenes
	var ability_scenes: Array[PackedScene] = [
		preload("res://scenes/abilities/fireball/fireball.tscn"),
		preload("res://scenes/abilities/water/water.tscn"),
		preload("res://scenes/abilities/wind/wind.tscn"),
		preload("res://scenes/abilities/earth/earth.tscn"),
	]

	# Spawn enemies in random positions around the mask
	for i in range(enemy_count):
		var enemy = wave.enemy_scene.instantiate()

		# Randomly assign an ability to the enemy
		var random_ability: PackedScene = ability_scenes.pick_random()
		if "ability_scene" in enemy:
			enemy.ability_scene = random_ability

		# Random position around mask
		var angle = randf() * TAU
		var distance = randf_range(spawn_radius * 0.5, spawn_radius)
		var offset = Vector3(cos(angle) * distance, 0, sin(angle) * distance)

		enemy.position = mask.position + offset
		enemy_container.add_child(enemy)

	wave_active = true
	wave_timer = 0.0


func _spawn_boss() -> void:
	var boss_enemy: CharacterBody3D = boss_enemy_scene.instantiate()
	boss_enemy.position = mask.position

	match GlobalState.unlocked_level:
		E.Level.Level1:
			GlobalSignals.boss_spawned.emit(E.Element.Water)
			boss_enemy.ability_scene = preload("res://scenes/abilities/water/water.tscn")
		E.Level.Level2:
			GlobalSignals.boss_spawned.emit(E.Element.Earth)
			boss_enemy.ability_scene = preload("res://scenes/abilities/earth/earth.tscn")
		E.Level.Level3:
			GlobalSignals.boss_spawned.emit(E.Element.Wind)
			boss_enemy.ability_scene = preload("res://scenes/abilities/wind/wind.tscn")
		E.Level.Level4:
			GlobalSignals.boss_spawned.emit(E.Element.Fire)
			boss_enemy.ability_scene = preload("res://scenes/abilities/fireball/fireball.tscn")

	enemy_container.add_child(boss_enemy)
	_boss_spawned = true
