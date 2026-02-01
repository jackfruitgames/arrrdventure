extends CharacterBody3D

@export var mouse_sensitivity: float = 0.002
@export var move_speed: float = 5.0
@export var jump_velocity: float = 4.5
@export var dash_speed: float = 20.0
@export var dash_duration: float = 0.3
@export var dash_cooldown: float = 1
@export var magic_cooldown: float = 0.5
@export var base_attack_cooldown: float = 0.8
@export var max_health: int = 200

var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
var current_health: int
var dash_timer: float = 0.0
var dash_cooldown_timer: float = 0.0
var magic_cooldown_timer: float = 0.0
var base_attack_cooldown_timer: float = 0.0
var is_dashing: bool = false
var dash_direction: Vector3 = Vector3.ZERO
var hud_instance: CanvasLayer = null
var selected_magic: E.AttackMode = E.AttackMode.Fire
var player_hud: PackedScene = preload("res://scenes/player/player_hud/player_hud.tscn")
var fireball_scene: PackedScene = preload("res://scenes/abilities/fireball/fireball.tscn")
var base_attack_scene: PackedScene = preload("res://scenes/abilities/base_attack/base_attack.tscn")

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
	if magic_cooldown_timer > 0:
		magic_cooldown_timer -= delta

	# Update base cooldown
	if base_attack_cooldown_timer > 0:
		base_attack_cooldown_timer -= delta

	# Update HUD
	if hud_instance:
		hud_instance.update_dash_cooldown(dash_cooldown_timer, dash_cooldown)
		hud_instance.update_magic_cooldown(magic_cooldown_timer, magic_cooldown)
		hud_instance.update_base_attack_cooldown(base_attack_cooldown_timer, base_attack_cooldown)

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

	# Handle magic selection (keys 1-4)
	if Input.is_action_just_pressed("select_magic_1"):
		selected_magic = E.AttackMode.Fire
		if hud_instance:
			hud_instance.update_selected_magic(E.AttackMode.Fire)
	elif Input.is_action_just_pressed("select_magic_2"):
		selected_magic = E.AttackMode.Water
		if hud_instance:
			hud_instance.update_selected_magic(E.AttackMode.Water)
	elif Input.is_action_just_pressed("select_magic_3"):
		selected_magic = E.AttackMode.Air
		if hud_instance:
			hud_instance.update_selected_magic(E.AttackMode.Air)
	elif Input.is_action_just_pressed("select_magic_4"):
		selected_magic = E.AttackMode.Earth
		if hud_instance:
			hud_instance.update_selected_magic(E.AttackMode.Earth)

	# Handle base attack (right mouse)
	if Input.is_action_just_pressed("attack_base"):
		shoot_base_attack()

	# Handle magic attack (left mouse)
	if Input.is_action_just_pressed("attack_magic"):
		use_magic_attack()

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
	if fireball_scene == null:
		return

	magic_cooldown_timer = magic_cooldown

	var fireball = fireball_scene.instantiate()
	get_tree().root.add_child(fireball)

	# Spawn in front of camera
	fireball.global_position = camera.global_position + (-camera.global_basis.z * 1.0)
	# Set direction to camera forward
	fireball.direction = -camera.global_basis.z
	# Set source group
	if "source_group" in fireball:
		fireball.source_group = "player"


func shoot_water() -> void:
	if fireball_scene == null:
		return

	magic_cooldown_timer = magic_cooldown

	# TODO: Replace with water scene when available
	var water = fireball_scene.instantiate()
	get_tree().root.add_child(water)

	water.global_position = camera.global_position + (-camera.global_basis.z * 1.0)
	water.direction = -camera.global_basis.z
	if "source_group" in water:
		water.source_group = "player"


func shoot_air() -> void:
	if fireball_scene == null:
		return

	magic_cooldown_timer = magic_cooldown

	# TODO: Replace with air scene when available
	var air = fireball_scene.instantiate()
	get_tree().root.add_child(air)

	air.global_position = camera.global_position + (-camera.global_basis.z * 1.0)
	air.direction = -camera.global_basis.z
	if "source_group" in air:
		air.source_group = "player"


func shoot_earth() -> void:
	if fireball_scene == null:
		return

	magic_cooldown_timer = magic_cooldown

	# TODO: Replace with earth scene when available
	var earth = fireball_scene.instantiate()
	get_tree().root.add_child(earth)

	earth.global_position = camera.global_position + (-camera.global_basis.z * 1.0)
	earth.direction = -camera.global_basis.z
	if "source_group" in earth:
		earth.source_group = "player"


func shoot_base_attack() -> void:
	if not base_attack_cooldown_timer <= 0:
		return
	if base_attack_scene == null:
		return

	base_attack_cooldown_timer = base_attack_cooldown

	var base_attack = base_attack_scene.instantiate()
	get_tree().root.add_child(base_attack)

	# Spawn in front of camera
	base_attack.global_position = camera.global_position + (-camera.global_basis.z * 1.0)
	# Set direction to camera forward
	base_attack.direction = -camera.global_basis.z
	# Rotate base to face direction of travel
	base_attack.look_at(base_attack.global_position + base_attack.direction)


func use_magic_attack() -> void:
	# Check if magic is on cooldown
	if magic_cooldown_timer > 0:
		return

	# Check if the selected magic is unlocked
	match selected_magic:
		E.AttackMode.Fire:
			if GlobalState.unlocked_level >= E.Level.Level2:
				shoot_fireball()
		E.AttackMode.Water:
			if GlobalState.unlocked_level >= E.Level.Level3:
				shoot_water()
		E.AttackMode.Air:
			if GlobalState.unlocked_level >= E.Level.Level4:
				shoot_air()
		E.AttackMode.Earth:
			if GlobalState.unlocked_level >= E.Level.Level5:
				shoot_earth()


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
	GlobalSignals.level_failed.emit(GlobalState.current_level)
	pass


func _on_tree_exited() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
