extends Area3D

@export var currentLevel: E.Level


func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		print("Dead by falling off...")
		GlobalSignals.start_level.emit(currentLevel)
