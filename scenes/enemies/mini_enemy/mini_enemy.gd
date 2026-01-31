extends Node3D

@export var sprite_texture: Texture2D


func _ready() -> void:
	assert(sprite_texture != null, "Enemy sprite texture missing!")
	$Sprite3D.texture = sprite_texture
