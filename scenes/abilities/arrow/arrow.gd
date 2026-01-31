extends Area3D

@export var speed: float = 30.0
@export var lifetime: float = 2.0

const DAMAGE := 25

var direction: Vector3 = Vector3.FORWARD
var timer: float = 0.0


func _physics_process(delta: float) -> void:
	global_position += direction * speed * delta

	timer += delta
	if timer >= lifetime:
		queue_free()


func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("enemy"):
		body.damage(DAMAGE)
	queue_free()


func _on_area_entered(area: Area3D) -> void:
	if area.is_in_group("enemy"):
		area.damage(DAMAGE)
	queue_free()
