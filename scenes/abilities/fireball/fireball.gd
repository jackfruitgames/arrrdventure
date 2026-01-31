extends Area3D

@export var speed: float = 20.0
@export var lifetime: float = 1.0

var direction: Vector3 = Vector3.FORWARD
var timer: float = 0.0


func _ready() -> void:
	body_entered.connect(_on_body_entered)


func _physics_process(delta: float) -> void:
	global_position += direction * speed * delta

	timer += delta
	if timer >= lifetime:
		queue_free()


func _on_body_entered(body: Node3D) -> void:
	if body.has_method("take_damage"):
		body.take_damage(1)
	queue_free()
