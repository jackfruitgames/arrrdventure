extends EnemyManager

# Example: Custom wave configuration for Level 3
# This level has more complex waves with 3 phases

func _configure_waves() -> void:
	# Workaround to not have to make huge changes to the EnemyManager :)
	waves.append(Wave.new(mini_enemy_scene, 0, 0, 1.0))
