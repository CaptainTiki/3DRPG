extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5
#Stores the x/y direction player is trying to look 
var _look : Vector2 = Vector2.ZERO

@export var mouse_sensitivity: float = 0.0025
@export var min_camera_rotation: float = -60
@export var max_camera_rotation: float = 10
@export var animation_smooth: float = 15.0

@onready var horizontal_pivot: Node3D = $HorizontalPivot
@onready var vertical_pivot: Node3D = $HorizontalPivot/VerticalPivot
@onready var rig_pivot: Node3D = $RigPivot
@onready var rig: Node3D = $RigPivot/Rig


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _physics_process(delta: float) -> void:
	frame_camera_rotation()
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var direction := get_movement_direction()
	rig.update_animation_tree(direction)
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		look_toward_direction(direction, delta)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("Escape_Key"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			_look = -event.relative * mouse_sensitivity
	
	if rig.is_idle():
		if event.is_action_pressed("Left_Click"):
			slash_attack()

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
	pass
