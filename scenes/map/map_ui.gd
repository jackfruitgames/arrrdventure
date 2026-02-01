extends CanvasLayer

@export var map: Node3D


func _on_exit_button_pressed() -> void:
	GlobalSignals.exit_game.emit()
	map.queue_free() # delete the map scene
