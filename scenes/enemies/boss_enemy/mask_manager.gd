extends Node

@export var fire_mask: Node3D
@export var water_mask: Node3D
@export var earth_mask: Node3D
@export var air_mask: Node3D


func _ready() -> void:
	assert(fire_mask != null, "pls fire_mask")
	assert(water_mask != null, "pls water_mask")
	assert(earth_mask != null, "pls earth_mask")
	assert(air_mask != null, "pls air_mask")
	match GlobalState.unlocked_level:
		E.Level.Level1:
			water_mask.show()
		E.Level.Level2:
			earth_mask.show()
		E.Level.Level3:
			air_mask.show()
		E.Level.Level4:
			fire_mask.show()
