extends EnemyManager

# Example: Custom wave configuration for Level 3
# This level has more complex waves with 3 phases

func _configure_waves() -> void:
	# Wave 1: 5-6 enemies, 25 second timer
	waves.append(Wave.new(mini_enemy_scene, 5, 6, 25.0))

	# Wave 2: 4-5 enemies, 20 second timer
	waves.append(Wave.new(mini_enemy_scene, 4, 5, 20.0))

	# Wave 3: 3-4 enemies, no timer (wait for all to die before boss)
	waves.append(Wave.new(mini_enemy_scene, 3, 4, 15.0))

	# Wave 4: 2-3 enemies, no timer (wait for all to die before boss)
	waves.append(Wave.new(mini_enemy_scene, 2, 3, 0.0))
