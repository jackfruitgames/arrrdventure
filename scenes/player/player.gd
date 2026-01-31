extends CharacterBody3D

@export var mouse_sensitivity: float = 0.002
@export var move_speed: float = 5.0
@export var jump_velocity: float = 4.5
@export var dash_speed: float = 20.0
@export var dash_duration: float = 0.3
@export var dash_cooldown: float = 1
@export var fireball_cooldown: float = 0.5

var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
var dash_timer: float = 0.0
var dash_cooldown_timer: float = 0.0
var fireball_cooldown_timer: float = 0.0
var is_dashing: bool = false
var dash_direction: Vector3 = Vector3.ZERO
var hud_instance: CanvasLayer = null
var player_hud: PackedScene = preload("res://scenes/player/player_hud/player_hud.tscn")
var fireball_scene: PackedScene = preload("res://scenes/abilities/fireball/fireball.tscn")

@onready var head: Node3D = $Head
@onready var camera: Camera3D = $Head/Camera3D


func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	if player_hud != null:
		hud_instance = player_hud.instantiate()
		add_child(hud_instance)


func _on_tree_exited() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func _unhandled_input(event: InputEvent) -> void:
	# Handle mouse events
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		# Rotate player horizontally (yaw)
		rotate_y(-event.relative.x * mouse_sensitivity)
		# Rotate head vertically (pitch), clamped to prevent over-rotation
		head.rotate_x(-event.relative.y * mouse_sensitivity)
		head.rotation.x = clamp(head.rotation.x, deg_to_rad(-89), deg_to_rad(89))

	# free mouse
	if event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

	# capture mouse
	if event is InputEventMouseButton and event.pressed:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _physics_process(delta: float) -> void:
	# Update dash cooldown
	if dash_cooldown_timer > 0:
		dash_cooldown_timer -= delta

	# Update fireball cooldown
	if fireball_cooldown_timer > 0:
		fireball_cooldown_timer -= delta

	# Update HUD
	if hud_instance:
		hud_instance.update_dash_cooldown(dash_cooldown_timer, dash_cooldown)
		hud_instance.update_fireball_cooldown(fireball_cooldown_timer, fireball_cooldown)

	# Update dash timer
	if is_dashing:
		dash_timer -= delta
		if dash_timer <= 0:
			is_dashing = false

	# Apply gravity
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jump_velocity

	# Get input direction
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	# Handle fireball
	if Input.is_action_just_pressed("fireball") and fireball_cooldown_timer <= 0:
		shoot_fireball()

	# Handle dash
	if Input.is_action_just_pressed("dash") and dash_cooldown_timer <= 0 and not is_dashing:
		is_dashing = true
		dash_timer = dash_duration
		dash_cooldown_timer = dash_cooldown
		# Dash in movement direction, or forward if not moving
		dash_direction = direction if direction else -transform.basis.z

	if is_dashing:
		velocity.x = dash_direction.x * dash_speed
		velocity.z = dash_direction.z * dash_speed
	elif direction:
		velocity.x = direction.x * move_speed
		velocity.z = direction.z * move_speed
	else:
		velocity.x = move_toward(velocity.x, 0, move_speed)
		velocity.z = move_toward(velocity.z, 0, move_speed)

	move_and_slide()


func shoot_fireball() -> void:
	print_debug("shooot fireball")
	if fireball_scene == null:
		return

	fireball_cooldown_timer = fireball_cooldown

	var fireball = fireball_scene.instantiate()
	get_tree().root.add_child(fireball)

	# Spawn in front of camera
	fireball.global_position = camera.global_position + (-camera.global_basis.z * 1.0)
	# Set direction to camera forward
	fireball.direction = -camera.global_basis.z
