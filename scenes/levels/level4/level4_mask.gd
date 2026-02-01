extends Area3D

func _on_player_entered(body: Node3D) -> void:
	if body.is_in_group("player") and get_parent_node_3d().is_visible_in_tree():
		GlobalSignals.finish_level.emit(E.Level.Level4)
