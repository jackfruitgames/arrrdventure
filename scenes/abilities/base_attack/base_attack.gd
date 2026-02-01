extends Area3D

@export var swing_duration: float = 0.2

const DAMAGE := 50

var timer: float = 0.0
var hit_enemies: Array[Node3D] = []
var slash_sprite: Sprite3D


func _ready() -> void:
	# Get the sprite
	slash_sprite = get_node_or_null("Sprite3D")

	if slash_sprite:
		# Start invisible
		slash_sprite.modulate.a = 0.0

		# Create swing animation with arc motion
		var tween = create_tween()
		tween.set_parallel(true)

		# Arc swing from right to left
		tween.tween_property(self, "rotation:y", deg_to_rad(-60), swing_duration).from(deg_to_rad(60)).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
		tween.tween_property(self, "rotation:z", deg_to_rad(15), swing_duration).from(deg_to_rad(-15)).set_ease(Tween.EASE_IN_OUT)

		# Slash trail fade in and out
		tween.tween_property(slash_sprite, "modulate:a", 0.9, swing_duration * 0.2)
		tween.tween_property(slash_sprite, "modulate:a", 0.0, swing_duration * 0.6).set_delay(swing_duration * 0.3)

		# Scale effect - slash grows then shrinks
		tween.tween_property(slash_sprite, "scale", Vector3(1.2, 1.5, 1.0), swing_duration * 0.3).from(Vector3(0.5, 0.5, 1.0))
		tween.tween_property(slash_sprite, "scale", Vector3(0.8, 1.0, 1.0), swing_duration * 0.5).set_delay(swing_duration * 0.3)

		# Position follows arc
		tween.tween_property(slash_sprite, "position:x", -0.2, swing_duration).from(0.3).set_ease(Tween.EASE_OUT)

		# Color flash effect - white flash at start, fade to normal
		var flash_color = Color(2.0, 2.0, 2.5, 1.0) # Bright white-blue
		var normal_color = Color(1.0, 1.0, 1.0, 1.0)
		tween.tween_property(slash_sprite, "modulate", normal_color, swing_duration * 0.4).from(flash_color)


func _physics_process(delta: float) -> void:
	timer += delta
	if timer >= swing_duration:
		queue_free()


func _on_body_entered(body: Node3D) -> void:
	# Only damage each enemy once per swing
	print_debug(body.name)
	if body.is_in_group("enemy") and body not in hit_enemies:
		hit_enemies.append(body)
		if body.has_method("damage"):
			body.damage(DAMAGE)


func _on_area_entered(area: Area3D) -> void:
	# Only damage each enemy once per swing
	if area.is_in_group("enemy") and area not in hit_enemies:
		hit_enemies.append(area)
		if area.has_method("damage"):
			area.damage(DAMAGE)
