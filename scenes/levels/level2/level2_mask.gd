extends Area3D

func _on_player_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		GlobalSignals.finish_level.emit(E.Level.Level2)
