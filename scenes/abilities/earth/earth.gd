extends Area3D

@export var speed: float = 10.0
@export var lifetime: float = 2.0

const DAMAGE := 100

var direction: Vector3 = Vector3.FORWARD
var timer: float = 0.0
var source_group: String = ""


func _ready() -> void:
	GlobalSignals.play_sound.emit(E.Sound.Fireball)


func _physics_process(delta: float) -> void:
	global_position += direction * speed * delta

	timer += delta
	if timer >= lifetime:
		queue_free()


func _on_body_entered(body: Node3D) -> void:
	# Don't damage entities in the same type as the source
	if body.is_in_group(source_group):
		return

	if body.has_method("damage"):
		body.damage(DAMAGE)
	queue_free()


func _on_area_entered(area: Area3D) -> void:
	# Don't damage entities in the same type as the source
	if area.is_in_group(source_group):
		return

	if area.has_method("damage"):
		area.damage(DAMAGE)
	queue_free()
