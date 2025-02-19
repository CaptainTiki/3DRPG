extends CharacterBody3D
class_name Player

@export var mouse_sensitivity: float = 0.0025
@export var min_camera_rotation: float = -60
@export var max_camera_rotation: float = 10
@export var animation_smooth: float = 15.0
@export var attack_move_speed: float = 3.0
@export_category("RPG Stats")
@export var stats : CharacterStats 

@onready var horizontal_pivot: Node3D = $HorizontalPivot
@onready var vertical_pivot: Node3D = $HorizontalPivot/VerticalPivot
@onready var rig_pivot: Node3D = $RigPivot
@onready var rig: Node3D = $RigPivot/Rig
@onready var attack_raycast: RayCast3D = %AttackRaycast
@onready var health_component: HealthComponent = $HealthComponent
@onready var collision_shape_3d: CollisionShape3D = $CollisionShape3D
@onready var area_attack: ShapeCast3D = $RigPivot/AreaAttack


const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const DECAY = 8.0
#Stores the x/y direction player is trying to look 
var _look : Vector2 = Vector2.ZERO
#Stores direction player is moving when attacking
var _attack_direction := Vector3.ZERO

var debug_on := false

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	health_component.update_max_health(30.0)

func _physics_process(delta: float) -> void:
	frame_camera_rotation()
	var direction := get_movement_direction()
	rig.update_animation_tree(direction)
	handle_jump_physics_frame()
	handle_idle_physics_frame(delta, direction)
	handle_slashing_physics_frame(delta)
	handle_overhead_attack_physics_frame()
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	move_and_slide()

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("Escape_Key"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			_look = -event.relative * mouse_sensitivity
	
	if Input.is_action_just_pressed("Debug_On"):
		if debug_on == true:
			debug_on = false
			print("Debug Off")
		else:
			debug_on = true
			print("Debug On")
	
	if Input.is_action_just_pressed("Level_Up"):
		if debug_on == true:
			print("leveling up")
			stats.level_up()
	
	if rig.is_idle():
		if event.is_action_pressed("Left_Click"):
			slash_attack()
		elif event.is_action_pressed("Right_Click"):
			overhead_attack()

func get_movement_direction() -> Vector3:
	var input_dir := Input.get_vector("Left_Strafe", "Right_Strafe", "Forward", "Backward")
	var input_vector :=Vector3(input_dir.x, 0, input_dir.y).normalized()
	return horizontal_pivot.global_transform.basis * input_vector

func frame_camera_rotation() -> void:
	horizontal_pivot.rotate_y(_look.x)
	vertical_pivot.rotate_x(_look.y)
	
	vertical_pivot.rotation.x = clampf(
		vertical_pivot.rotation.x,
		deg_to_rad(min_camera_rotation),
		deg_to_rad(max_camera_rotation)
		)
	
	_look = Vector2.ZERO

func look_toward_direction(direction: Vector3, delta: float) -> void:
	var target_transform := rig_pivot.global_transform.looking_at(
		rig_pivot.global_position + direction,
		Vector3.UP,
		true
	)
	rig_pivot.global_transform = rig_pivot.global_transform.interpolate_with(
		target_transform, 
		1.0 - exp(-animation_smooth * delta)
	)

func slash_attack() -> void:
	rig.travel("Slash")
	_attack_direction = get_movement_direction()
	if _attack_direction.is_zero_approx():
		_attack_direction = rig.global_basis * Vector3(0,0,1) #0,0,1 is the facing direction of the player
	attack_raycast.clear_exceptions()

func overhead_attack() -> void:
	rig.travel("Overhead")
	_attack_direction = get_movement_direction()
	if _attack_direction.is_zero_approx():
		_attack_direction = rig.global_basis * Vector3(0,0,1) #0,0,1 is the facing direction of the player
	attack_raycast.clear_exceptions()

func handle_idle_physics_frame(delta: float, direction:Vector3) -> void:
	if not rig.is_idle() and not rig.is_dashing():
		return
	velocity.x = exponential_decay(velocity.x, direction.x * SPEED, DECAY, delta)
	velocity.z = exponential_decay(velocity.z, direction.z * SPEED, DECAY, delta)
	#if there is a direction of movement - point that way
	if direction:
		look_toward_direction(direction, delta)

func handle_slashing_physics_frame(delta: float) -> void:
	if not rig.is_slashing():
		return
	velocity.x = _attack_direction.x * attack_move_speed
	velocity.z = _attack_direction.z * attack_move_speed
	look_toward_direction(_attack_direction, delta)
	attack_raycast.deal_damage()

func handle_overhead_attack_physics_frame() -> void:
	if not rig.is_overhead_attack():
		return
	velocity = Vector3.ZERO
	pass

func handle_jump_physics_frame() -> void:
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	pass


func _on_health_component_defeat() -> void:
	rig.travel("Defeat") #animate the death animation
	collision_shape_3d.disabled = true #disable collision with this char
	set_physics_process(false) #turn off gravity


func _on_rig_heavy_attack() -> void:
	area_attack.deal_damage(50.0)

func exponential_decay(a: float, b: float, decay: float, delta: float) -> float:
	return b + (a - b) * exp(-decay * delta)
