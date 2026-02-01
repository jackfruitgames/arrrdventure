extends EnemyManager

func _configure_waves() -> void:
	# 1 to 2 enemies, next wave after 30s
	waves.append(Wave.new(mini_enemy_scene, 1, 2, 20.0))
	# 3 to 4 enemies, no next wave
	waves.append(Wave.new(mini_enemy_scene, 3, 4, 00.0))
