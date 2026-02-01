extends EnemyManager

func _configure_waves() -> void:
	# 2 to 4 enemies, next wave after 30s
	waves.append(Wave.new(mini_enemy_scene, 2, 4, 30.0))
	# 23 to 5 enemies, no next wave
	waves.append(Wave.new(mini_enemy_scene, 3, 5, 0.0))
