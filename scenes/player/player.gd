extends CharacterBody3D

@export var mouse_sensitivity: float = 0.002
@export var move_speed: float = 5.0
@export var jump_velocity: float = 4.5
@export var dash_speed: float = 20.0
@export var dash_duration: float = 0.3
@export var dash_cooldown: float = 1
@export var fireball_cooldown: float = 0.5
@export var arrow_cooldown: float = 0.8
@export var max_health: int = 100

var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
var current_health: int
var dash_timer: float = 0.0
var dash_cooldown_timer: float = 0.0
var fireball_cooldown_timer: float = 0.0
var arrow_cooldown_timer: float = 0.0
var is_dashing: bool = false
var dash_direction: Vector3 = Vector3.ZERO
var hud_instance: CanvasLayer = null
var player_hud: PackedScene = preload("res://scenes/player/player_hud/player_hud.tscn")
var fireball_scene: PackedScene = preload("res://scenes/abilities/fireball/fireball.tscn")
var arrow_scene: PackedScene = preload("res://scenes/abilities/arrow/arrow.tscn")

@onready var head: Node3D = $Head
@onready var camera: Camera3D = $Head/Camera3D


func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	current_health = max_health
	if player_hud != null:
		hud_instance = player_hud.instantiate()
		add_child(hud_instance)
		hud_instance.update_health(current_health, max_health)


func _physics_process(delta: float) -> void:
	# Update dash cooldown
	if dash_cooldown_timer > 0:
		dash_cooldown_timer -= delta

	# Update fireball cooldown
	if fireball_cooldown_timer > 0:
		fireball_cooldown_timer -= delta

	# Update arrow cooldown
	if arrow_cooldown_timer > 0:
		arrow_cooldown_timer -= delta

	# Update HUD
	if hud_instance:
		hud_instance.update_dash_cooldown(dash_cooldown_timer, dash_cooldown)
		hud_instance.update_fireball_cooldown(fireball_cooldown_timer, fireball_cooldown)
		hud_instance.update_arrow_cooldown(arrow_cooldown_timer, arrow_cooldown)

	# Get input direction
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	# Handle dash
	if Input.is_action_just_pressed("dash") and dash_cooldown_timer <= 0 and not is_dashing:
		is_dashing = true
		dash_timer = dash_duration
		dash_cooldown_timer = dash_cooldown
		# Dash in movement direction, or forward if not moving
		dash_direction = direction if direction else -transform.basis.z
		velocity.x = dash_direction.x * dash_speed
		velocity.z = dash_direction.z * dash_speed

	if is_dashing:
		dash_timer -= delta
		if dash_timer <= 0:
			is_dashing = false
	elif direction:
		velocity.x = direction.x * move_speed
		velocity.z = direction.z * move_speed
	else:
		velocity.x = move_toward(velocity.x, 0, move_speed)
		velocity.z = move_toward(velocity.z, 0, move_speed)

	# Apply gravity
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jump_velocity

	# Handle arrow (Level 1 ability)
	if Input.is_action_just_pressed("arrow"):
		shoot_arrow()

	# Handle fireball (unlocked at Level2+)
	if Input.is_action_just_pressed("fireball"):
		shoot_fireball()

	move_and_slide()


func _unhandled_input(event: InputEvent) -> void:
	# Handle camera movements
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		# Rotate player horizontally (yaw)
		rotate_y(-event.relative.x * mouse_sensitivity)
		# Rotate head vertically (pitch), clamped to prevent over-rotation
		head.rotate_x(-event.relative.y * mouse_sensitivity)
		head.rotation.x = clamp(head.rotation.x, deg_to_rad(-89), deg_to_rad(89))

	# Free mouse
	if event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

	# Capture mouse
	if event is InputEventMouseButton and event.pressed:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func shoot_fireball() -> void:
	if fireball_cooldown_timer > 0 and GlobalState.unlocked_level < E.Level.Level2:
		return

	if fireball_scene == null:
		return

	fireball_cooldown_timer = fireball_cooldown

	var fireball = fireball_scene.instantiate()
	get_tree().root.add_child(fireball)

	# Spawn in front of camera
	fireball.global_position = camera.global_position + (-camera.global_basis.z * 1.0)
	# Set direction to camera forward
	fireball.direction = -camera.global_basis.z


func shoot_arrow() -> void:
	if not arrow_cooldown_timer <= 0:
		return
	if arrow_scene == null:
		return

	arrow_cooldown_timer = arrow_cooldown

	var arrow = arrow_scene.instantiate()
	get_tree().root.add_child(arrow)

	# Spawn in front of camera
	arrow.global_position = camera.global_position + (-camera.global_basis.z * 1.0)
	# Set direction to camera forward
	arrow.direction = -camera.global_basis.z
	# Rotate arrow to face direction of travel
	arrow.look_at(arrow.global_position + arrow.direction)


func use_ability_level3() -> void:
	if GlobalState.unlocked_level < E.Level.Level3:
		return
	# TODO: Implement Level 3 ability
	pass


func use_ability_level4() -> void:
	if GlobalState.unlocked_level < E.Level.Level4:
		return
	# TODO: Implement Level 4 ability
	pass


func damage(dmg: int) -> void:
	current_health -= dmg
	if hud_instance:
		hud_instance.update_health(current_health, max_health)
	if current_health <= 0:
		_on_dead()


func _on_dead() -> void:
	# TODO: Handle player death
	pass


func _on_tree_exited() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
