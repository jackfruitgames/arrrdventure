extends Node3D

@export var animation: AnimationPlayer


func _ready() -> void:
	animation.play("ship_wiggle")
