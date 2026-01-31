extends Area3D

@export var islandLevel: E.Level


func _ready() -> void:
	assert(islandLevel != null, "island has no level!")


func _on_body_entered(body: Node3D) -> void:
	print("Collide")
	print("Unlocked_level: " + str(GlobalState.unlocked_level) + ", this island has " + str(islandLevel))
	if body.is_in_group("player") and islandLevel == GlobalState.unlocked_level:
		print("Start next level!")
		GlobalSignals.start_level.emit(islandLevel)
