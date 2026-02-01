extends Area3D

@export var islandLevel: E.Level
@export var mask: Node3D
@export var tree: Node3D
@export var map: Node3D
@export var xmark: Node3D


func _ready() -> void:
	assert(islandLevel != null, "island has no level!")
	assert(map != null, "map is null")
	if GlobalState.unlocked_level > islandLevel:
		mask.show()
		tree.hide()
	else:
		mask.hide()
		tree.show()

	if GlobalState.unlocked_level == islandLevel:
		xmark.show()
	else:
		xmark.hide()


func _on_body_entered(body: Node3D) -> void:
	print("Unlocked_level: " + str(GlobalState.unlocked_level) + ", this island has " + str(islandLevel))
	if body.is_in_group("player") and islandLevel == GlobalState.unlocked_level:
		print("Start next level!")
		GlobalSignals.start_level.emit(islandLevel)
